module Web
  module Ver1
    #companys 公司 接口 api相关
    module Companys
      class CompanyAPI < BaseAPI

        # 引入 公司相关helper方法
        helpers ::CompanyHelper::CompanyapiHelper

        #命名空间 company
        namespace :company do

          desc '添加公司'
          params do
            
          end


          desc '获取公司列表'
          params do
            #此处会将 string 转换为 Integer,关于字段 对应 的 中文 配置,可以去 /config 下配置 yml 文件,
            # 例如 此处 配置文件 的 位置就是 \config\api\web\ver1\companys\company_api.yml
            optional :page, type: Integer, desc: '当前页'
            optional :per_page, type: Integer, default: 10, desc: '每页条数,默认10'
            optional :company_name, type: String, desc: '公司名称'
            optional :followup_employee_id, type: Integer, default: 0, desc: '跟进人ID'
          end
          get :list do
            begin
              success_return get_company_list(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,获取公司列表数据失败,请重试'
            end
          end

          desc '获取公司详情'
          params do
            #此处会将 string 转换为 Integer
            requires :id, type: Integer, desc: '公司ID'
          end
          get :detail do
            begin
              success_return get_company_info(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,获取公司详情失败,请重试'
            end
          end

          desc '添加公司联系人'
          params do
            #此处会将 string 转换为 Integer
            requires :name, type: String, desc: '联系人姓名'
            requires :mobile, type: String, desc: '联系人手机,此处手机会有多个'
            requires :company_id, type: Integer, desc: '联系人公司ID,必传'
          end
          post :add_contact do
            begin
              success_return add_contact(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,添加联系人失败,请重试'
            end
          end
        end
      end
    end
  end
end

