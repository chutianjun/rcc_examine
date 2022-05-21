module CompanyHelper
  module CompanyapiHelper
    #获取公司的列表信息
    def get_company_list(params)

      #公司总数
      company_total = Company.count
      #搜索公司,此处 includes 避免 n+1
      company_search = Company.select(:id, :company_name, :company_phone, :company_postcode, :company_address, :followup_employee_id).includes(:follow_up_employee)
      #公司名称搜索
      company_search.where!('name like ? ', "%#{params[:company_name]}%") if params[:company_name].present?
      #跟进员工ID搜索
      company_search.where!(followup_employee_id: params[:followup_employee_id]) if params[:followup_employee_id] > 0
      #当前所在页数
      params[:page] ||= 1
      #每页条数
      params[:per_page] ||= 10
      offset_current = params[:page] - 1
      offset_current = (offset_current < 0) ? 0 : offset_current
      offset_size = offset_current * params[:per_page]
      new_company_list = company_search.limit!(params[:per_page]).offset!(offset_size).map do |item|
        new_item = item.as_json
        new_item[:follow_up_employee_name] = item.follow_up_employee.employee_name
        new_item
      end
      { company_data: new_company_list, total: company_total }
    end

    #获取公司详情
    def get_company_info(params)
      company_info = Company.select(:id, :company_name, :company_phone, :company_postcode, :company_address, :followup_employee_id)
                            .where(id: params["id"]).take
      company_data = company_info.as_json
      company_data[:follow_up_employee] = company_info.follow_up_employee
      company_data
    end

    #  添加联系人
    def add_contact(params)
      #校验多个手机号是否正确
      reject_mobile = params[:mobile].split(',').reject do |item|
        if item =~ /^1(3\d|4[5-9]|5[0-35-9]|6[567]|7[0-8]|8\d|9[0-35-9])\d{8}$/
          item
        end
      end
      if reject_mobile.size > 0
        error_mobile_coll = '[' + reject_mobile.join('],[') + ']'
        raise_json msg: '抱歉,以下手机号格式有误,请仔细检查' + error_mobile_coll, code: 101
      end

      #对公司ID进行校验 ,如果 公司 信息不存在,报错
      company_details = Company.select(:id, :company_name).where(id: params[:company_id]).take

      unless company_details
        raise_json msg: '抱歉,该公司ID有误,公司并不存在,请仔细检查', code: 102
      end

      create_data = {
        name: params[:name],
        sex: params[:sex],
        #部门
        department: params[:department],
        #重要性
        importance: params[:importance],
        #多个手机号
        mobile: params[:mobile],
        email: params[:email],
        #电话
        phone: params[:phone],
        remark: params[:remark],
        #联系人公司ID,必传
        company_id: params[:company_id]
      }
      #开启事务
      ActiveRecord::Base.transaction do
        #password 在数据库中 实际 不存在
        Contact.create!(create_data)
      end
    end

  end
end
