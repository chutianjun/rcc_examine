module Web
  module Ver1
    #v1 版本 所有 接口的 父类
    class BaseAPI < Grape::API

      @@curr_request_path = nil
      # inherited 钩子，一旦有 子类继承  inherited 钩子就会 被触发
      def self.inherited(subclass)
        super
        #class_eval 来 打开 扩展类
        subclass.class_eval do
          #before 前置方法
          before do
            @@curr_request_path = request.env['REQUEST_PATH']
            asterisk = "*" * 25
            asterisk += Time.now.to_s + asterisk
            Rails.logger.debug " #{asterisk}\n params is: #{params.inspect}\n \n headers is: #{headers.inspect}\n #{asterisk}\n "
          end

          rescue_from RuntimeError do |e|
            abnormal_data = JSON.parse(e.to_s)
            abnormal_data["msg"] ||= '操作失败'
            abnormal_data['code'] ||= 400
            return_exception = error_return abnormal_data["msg"], abnormal_data['code']
            rack_response(format_message(return_exception, e.backtrace), 201)
          end

          # v1 版本 接口 定义 全局  参数 异常 处理
          rescue_from Grape::Exceptions::ValidationErrors do |e|
            begin
              # 默认 错误
              err_msg = e.message
              unless @@curr_request_path
                raise_json msg: '抱歉,系统缺少重要参数,请重试101'
              end

              configuration_file_path = Rails.root.join('config', 'api', subclass.to_s.underscore.split('::').join('/'))
              #配置文件存在
              unless File.exist? configuration_file_path.to_s + '.yml'
                raise_json msg: '抱歉,没有配置文件,请重试102'
              end

              requires_field_list = Config.load_files(configuration_file_path.to_s + '.yml')
              error_mapping = requires_field_list[@@curr_request_path.split('/').last]

              unless error_mapping
                raise_json msg: '抱歉,配置文件中没有相关数据,请重试103'
              end

              #对应的值存在
              error_mapping = error_mapping.to_hash
              error_params = []
              e.as_json.each do |value|
                unless error_mapping[value[:params].join('').to_sym].blank?
                  error_params << error_mapping[value[:params].join('').to_sym]
                end
              end

              if error_params.size > 0
                err_msg = '[' + error_params.join('],[') + '] 填写错误,请仔细检查'
              end


              message = error_return err_msg
              rack_response(format_message(message, e.backtrace), 201)
            rescue RuntimeError => e
              abnormal_data = JSON.parse(e.to_s)
              return_exception = error_return abnormal_data["msg"]
              rack_response(format_message(return_exception, e.backtrace), 201)
            end
          end
        end
      end
    end
  end
end
