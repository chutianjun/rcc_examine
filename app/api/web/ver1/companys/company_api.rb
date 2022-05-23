module Web
  module Ver1
    #companys 公司 接口 api相关
    module Companys
      class CompanyAPI < BaseAPI

        # 引入 公司相关helper方法
        helpers ::CompanyHelper::CompanyapiHelper

        helpers do
          #跟进任务相关字段
          params :task_follow_field_coll do
            requires :arrange_time, type: DateTime, desc: '安排时间', allow_blank: false
            #此处会将 string 转换为 Integer
            requires :follower_id, type: Integer, desc: '跟进人', allow_blank: false
            requires :contact_id, type: Integer, desc: '联系人', allow_blank: false
            requires :contact_information, type: Integer, desc: '联系方式', allow_blank: false
            requires :followup_phase, type: String, desc: '跟进阶段', allow_blank: false
            requires :company_id, type: Integer, desc: '公司ID', allow_blank: false
            optional :followup_status, type: Integer, desc: '跟进状态'
          end
          params :task_follow_id do
            requires :id, type: Integer, desc: '跟进任务ID', allow_blank: false
          end
          #公司ID
          params :company_id do
            requires :company_id, type: Integer, desc: '公司ID,必传'
          end
        end

        #命名空间 company
        namespace :company do
          #添加公司 start
          desc '添加公司'
          params do
            requires :company_name, type: String, desc: '公司名称', allow_blank: false
          end
          post :add do
            begin
              add_company(params)
              #如果 model 层检测 到字段 的错误
              if @add_company_result[:errors].size >= 1
                raise_json msg: @add_company_result[:errors].join(',')
              end
              success_return @add_company_result[:instance_data], '添加公司成功'
              # ActiveRecord 抛出的异常
            rescue ActiveRecord::RecordInvalid => e
              logger_error e
              error_return e.message
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,添加公司失败,请重试'
            end
          end
          #添加公司 end

          # 删除公司 start
          desc '删除公司'
          params do
            use :company_id
          end
          post :del do
            begin
              del_company(params)
              success_return @del_company_result, '删除公司成功'
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,删除公司失败,请重试'
            end
          end
          # 删除公司 end

          #添获取公司列表 start
          desc '获取公司列表'
          params do
            #关于 检测 字段 对应 的 中文 配置,可以去 /config 下配置 yml 文件,
            # 例如 此处 配置文件 的 位置就是 \config\api\web\ver1\companys\company_api.yml
            # 和api下的目录结构对应
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

          #添获取公司列表 end

          # 获取公司详情 start
          desc '获取公司详情'
          params do
            #此处会将 string 转换为 Integer
            use :company_id
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

          # 获取公司详情 end

          # 添加公司联系人 start

          desc '添加公司联系人'
          params do
            #此处会将 string 转换为 Integer
            requires :name, type: String, desc: '联系人姓名'
            requires :mobile, type: String, desc: '联系人手机,此处手机会有多个'
            use :company_id
          end
          post :add_contact do
            begin
              add_contact(params)

              if @add_contact_return[:errors].size >= 1
                raise_json msg: @add_contact_return[:errors].join(',')
              end

              success_return @add_contact_return[:instance_data], '添加成功'
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,添加联系人失败,请重试'
            end
          end

          # 添加公司联系人 end

          desc '公司联系人列表'
          params do
            use :company_id
          end
          get :contact_list do
            begin
              success_return get_company_contact_list(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,获取联系人列表数据失败,请重试'
            end
          end



          # 添加跟进任务 start
          desc '添加跟进任务'
          params do
            #跟进任务相关字段要求
            use :task_follow_field_coll
          end
          post :add_follow do
            begin
              add_follow(params)
              if @add_follow_return[:errors].size >= 1
                raise_json msg: @add_follow_return[:errors].join(',')
              end
              success_return @add_follow_return[:instance_data], '添加跟进任务成功'
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,添加跟进任务失败,请重试'
            end
          end
          # 添加跟进任务 end

          # 修改跟进任务 start
          desc '修改跟进任务'
          params do
            #跟进任务字段相关要求
            use :task_follow_field_coll
            use :task_follow_id
          end
          post :edit_follow do
            begin
              edit_follow(params)

              if @edit_follow_return[:errors].size >= 1
                raise_json msg: @edit_follow_return[:errors].join(',')
              end
              success_return @edit_follow_return[:instance_data], '修改跟进任务成功'
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,修改跟进任务失败,请重试'
            end
          end
          # 修改跟进任务 end


          #获取跟进任务列表 s
          desc '获取跟进任务列表'
          params do
            use :company_id
          end
          get :follow_task_list do
            begin
              success_return follow_task_list(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,获取跟进列表数据失败,请重试'
            end
          end
          #获取跟进任务列表 e
          #
          #

          #获取所有员工的列表信息
          desc '获取员工列表'
          params do
          end
          get :get_employees do
            begin
              success_return get_employees_list(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,获取跟进列表数据失败,请重试'
            end
          end


          # 删除跟进任务 start
          desc '删除跟进任务'
          params do
            use :task_follow_id
          end
          post :del_follow do
            begin
              del_follow(params)
              success_return @del_follow_result
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,删除跟进任务失败,请重试'
            end
          end

          # 删除跟进任务 end


          desc '获取跟进任务详情'
          params do
            requires :follow_id, type: String, desc: '跟进任务ID', allow_blank: false
          end
          get :get_follow do
            begin
              success_return  get_simple_follow(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,获取跟进任务失败,请重试'
            end
          end



          # 跟进任务批量完成 start
          desc '跟进任务批量完成'
          params do
            requires :task_ids, type: String, desc: '跟进任务ID', allow_blank: false
          end

          post :task_batch_done do
            begin
              success_return task_batch_done(params)
            rescue Exception => e
              #记录异常
              logger_error e
              error_return '抱歉,更新跟进状态失败,请重试'
            end
          end
          # 跟进任务批量完成 end


          desc '查询没有跟进任务的公司'
          params do
          end
          get :no_follow_up do
            success_return ::Company.no_follow_up_tasks
          end


          desc '一条语句返回跟进任务列表需要的数据'
          get :follow_up_by_one do
            success_return ::FollowRecord.get_follow_list_data
          end

        end
      end
    end
  end
end

