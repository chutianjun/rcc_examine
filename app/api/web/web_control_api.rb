module Web
  class WebControlAPI < Grape::API
    #json格式化
    format :json
    #公共的helper方法
    helpers ::CommonHelper::CommonapiHelper

    #before 前置方法
    before do
      begin
        # 排除 接口 白名单,不需要校验
        white_list_config = Config.load_files(Rails.root.to_s + '/config/custom/white_route_list.yml').token_white_list
        curr_uri = (request.env['REQUEST_PATH'])
        unless white_list_config[curr_uri]
          http_token ||= if request.headers['Authorization'].present?
                           request.headers['Authorization'].split(' ').last
                         end

          unless http_token
            raise_json msg: 'sorry,no tokan value,please login again', code: 201
          end

          auth_token ||= Token.decode(http_token)

          if !auth_token || auth_token[:user_id].blank? || auth_token[:user_password].blank?
            raise_json msg: 'sorry,token error,please login again', code: 202
          end

          @current_user = Employee.find_by(id: auth_token[:user_id])

          unless @current_user
            raise_json = { msg: 'sorry,user does not exist or error,please login again', code: 203 }.to_json
            raise raise_json
          end

          if @current_user.password_digest != auth_token["user_password"]
            raise_json msg: 'sorry wrong user password', code: 204
          end

        end
      rescue JWT::ExpiredSignature
        raise_json msg: 'sorry,token is  expired,please login again', code: 205
      rescue Exception => e
        logger_error e
        raise_json msg: 'sorry,unknown exception occurred', code: 206
      end

    end

    #所有 v1  版本接口 的挂载 入口
    mount Ver1::MountAPI

  end
end