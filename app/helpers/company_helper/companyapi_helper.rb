module CompanyHelper
  module CompanyapiHelper
    #获取公司的列表信息
    def get_company_list(params)
      #写SQL查询出没有跟进任务的公司。(写在公司model类中)

      company_model_data = ::Company.get_company_list(params)
      database_data = company_model_data[:database_data]
      company_data = database_data.map do |item|
        new_item = item.as_json
        new_item[:follow_up_employee] = item.follow_up_employee
        new_item
      end
      { company_data: company_data, total: company_model_data[:company_total] }
    end

    #获取公司详情
    def get_company_info(params)
      company_info = ::Company.select(:id, :company_name, :company_phone, :company_postcode, :company_address, :followup_employee_id)
                              .where(id: params["company_id"]).take
      company_data = company_info.as_json
      #当前跟进人员数据
      company_data[:follow_up_employee] = company_info.try!(:follow_up_employee)
      # 此处是 示范 一个接口返回全部 相关 数据
      #
      #公司联系人数据
      # company_data[:contacts] = company_info.try!(:contacts)
      # #公司的跟进数据 集合
      # record_data = []
      # # includes 解决 n+1 循环 读取数据库问题
      # company_info.try!(:follow_records).includes(:follow_user, :contact, :create_user).each do |item|
      #   new_follow_record = Hash.new
      #   new_follow_record[:follow_records] = item.as_json
      #   #跟进人
      #   new_follow_record[:follow_records][:follow_user] = item.try!(:follow_user)
      #   #联系人
      #   new_follow_record[:follow_records][:contact] = item&.contact
      #   #创建人
      #   new_follow_record[:follow_records][:create_user] = item.try!(:create_user)
      #   record_data << new_follow_record
      # end
      # company_data[:record_follow_data] = record_data

      { company_data: company_data }
    end

    #获取公司联系人列表
    def get_company_contact_list(params)
      result = ::Contact.select(:id, :name, :mobile, :phone, :email, :importance, :department, :sex, :remark).where(company_id: params[:company_id]).order(id: :desc)
      result.map do |item|
        new_mobile = item.mobile.split(',').map do |x|
          x.tap { |a| a[3...8] = "****" }
        end
        item.tap { |b| b.mobile = new_mobile.join(',') }
      end
      { result: result }
    end

    #添加联系人
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
      company_details = ::Company.select(:id, :company_name).where(id: params[:company_id]).take

      unless company_details
        raise_json msg: '抱歉,该公司ID有误,公司并不存在,请仔细检查', code: 102
      end

      field_list = %w[name sex department importance mobile email phone remark company_id]
      create_data = param_builder(params, field_list)
      #开启事务
      ActiveRecord::Base.transaction do
        contact_instanct = Contact.create(create_data)
        @add_contact_return = { errors: contact_instanct.errors.messages.values, instance_data: { contact_instanct: contact_instanct } }
      end
    end

    #添加公司的跟进记录
    def add_follow(params)
      file_name = %w[arrange_time follower_id contact_id contact_information followup_phase remark followup_status company_id]
      company_follow_data = param_builder(params, file_name)
      #创建用户ID
      company_follow_data[:create_user_id] = @current_user.id
      #开启事务
      ActiveRecord::Base.transaction do
        # FollowRecord.create!(company_follow_data)
        follow_record_instance = ::FollowRecord.create(company_follow_data)
        #修改公司当前 跟进人
        Company.find_by_id(follow_record_instance.company_id).update_attribute(:followup_employee_id, follow_record_instance.follower_id)
        @add_follow_return = { errors: follow_record_instance.errors.messages.values, instance_data: { follow_record_instance: follow_record_instance } }
      end
    end

    #添加公司
    def add_company(params)
      company_instance = ::Company.new
      data_field = %w[company_name company_phone company_postcode company_address]
      data_field.each do |item|
        # 动态赋值
        # 方式一
        # eval "company_instance.#{item}=params[item] "
        #
        # 方式二
        company_instance.send(item + '=', params[item])
        #
        # 方式三
        # company_instance.try(item+'=',params[item])
      end
      #跟进人ID,如果没有传入跟进人id，就用当前用户的id
      company_instance.followup_employee_id = (params[:followup_employee_id].present? && params[:followup_employee_id].to_i > 0) ? params[:followup_employee_id] : @current_user.id

      # create 数据的方式
      #
      # create_company_data = {
      #   #公司名称
      #   company_name: params[:company_name],
      #   #公司电话
      #   company_phone: params[:company_phone],
      #   #公司邮编
      #   company_postcode: params[:company_postcode],
      #   #公司地址
      #   company_address: params[:company_address],
      # }
      # create_company_data[:followup_employee_id] = 1
      #
      #
      #开启事务
      ActiveRecord::Base.transaction do
        #
        # 爆炸方法会直接抛出异常,这里 我们 要获得 model 模型对 字段的 检测 效果,就不用爆炸方法了
        #
        # create 的方式写入
        # Company.create!(create_company_data)
        #
        # save 方式
        # company_instance.save!
        #
        company_instance.save
        @add_company_result = { errors: company_instance.errors.messages.values, instance_data: { company_instance: company_instance } }
      end
    end

    #删除公司
    def del_company(params)
      #查询 公司是否存在
      exist_company = ::Company.find_by_id(params[:company_id])

      unless exist_company
        raise_json msg: '抱歉,该公司不存在,请重试'
      end

      #开启事务
      ActiveRecord::Base.transaction do
        @del_company_result = exist_company.destroy!
      end
    end

    #批量更新跟进 记录 状态
    def task_batch_done(params)
      follow_task_ids = params[:task_ids].split(',').uniq.reject { |x| x.blank? || x.to_i <= 0 }
      #开启事务
      ActiveRecord::Base.transaction do
        #修改跟进状态为 已完成
        update_result = ::FollowRecord.where("id in (?)", follow_task_ids).update_all(followup_status: 2)
        { update_result: update_result }
      end
    end

    #  修改跟进任务
    def edit_follow(params)
      #查询 跟进任务是否存在
      exist_follow = ::FollowRecord.find_by_id(params[:id])

      unless exist_follow
        raise_json msg: '抱歉,该跟进数据不存在,请重试'
      end

      data_field = %w[arrange_time follower_id contact_id contact_information followup_phase remark followup_status company_id]
      follow_record = dynamic_object_assignment(exist_follow, params, data_field)

      #开启事务
      ActiveRecord::Base.transaction do
        follow_record.save
        #修改公司当前 跟进人
        Company.find_by_id(follow_record.company_id).update_attribute(:followup_employee_id, follow_record.follower_id)
      end
      @edit_follow_return = { errors: follow_record.errors.messages.values, instance_data: { follow_record: follow_record } }
    end

    #获取跟进任务列表
    def follow_task_list(params)
      result = ::FollowRecord.select(:id, :arrange_time, :follower_id, :created_at, :create_user_id, :contact_id, :contact_information, :followup_phase, :remark, :company_id, :followup_status).where(company_id: params[:company_id]).includes(:follow_user, :contact, :create_user)
      new_result = []
      result.each do |item|
        new_follow_record = item.as_json
        new_follow_record["arrange_time"] = convert_time_to_string(new_follow_record["arrange_time"])
        new_follow_record["created_at"] = convert_time_to_string(new_follow_record["created_at"])
        #跟进人
        new_follow_record[:follow_user] = item.try!(:follow_user)
        #联系人
        new_follow_record[:contact] = item&.contact
        #创建人
        new_follow_record[:create_user] = item.try!(:create_user)
        new_result << new_follow_record
      end

      { result: new_result }
    end

    #  删除跟进任务
    def del_follow(params)
      #查询 跟进任务是否存在
      exist_follow = ::FollowRecord.find_by_id(params[:id])

      unless exist_follow
        raise_json msg: '抱歉,该跟进数据不存在,请重试'
      end
      #开启事务
      ActiveRecord::Base.transaction do
        @del_follow_result = exist_follow.destroy!
      end
    end

    #获取跟进任务详情
    def get_simple_follow(params)
      { follow_data: ::FollowRecord.find_by_id(params[:follow_id]) }
    end

    #获取员工列表
    def get_employees_list(params)
      { employee_data: ::Employee.select(:id, :employee_name).all }
    end

  end
end
