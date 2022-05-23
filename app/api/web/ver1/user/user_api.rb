module Web
  module Ver1
    module User
      class UserAPI < BaseAPI
        #  引入用户的helper相关
        helpers ::UserHelper::UserapiHelper

        namespace :user do

          desc '添加用户'
          params do
            #requires 必填,allow_blank  false 不能为空
            requires :employee_name, type: String, desc: '用户名', allow_blank: false
            requires :password, type: String, desc: '密码', allow_blank: false
          end
          post 'add' do
            begin
              success_return save_user(params)
            rescue Exception => e
              logger_error e
              error_return '抱歉,添加用户失败,请重试'
            ensure
            end
          end

          desc '用户登录,并且获取token值'
          params do
            requires :employee_name, type: String, desc: '用户名', allow_blank: false
            requires :password, type: String, desc: '密码', allow_blank: false
          end
          post 'login' do
            begin
              success_return login_user(params)
            rescue Exception => e
              logger_error e
              error_return '抱歉,添加用户失败,请重试'
            ensure
            end
          end
        end

      end
    end
  end
end