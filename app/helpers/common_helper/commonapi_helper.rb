module CommonHelper
  module CommonapiHelper
    def print_asterisk
      p "*" * 15 + Time.now.to_s + '*' * 15
    end

    def dd(*args)
      print_asterisk
      args.each_with_index { |item, index| p 'param ' + (index + 1).to_s + ":"; p item; p '-' * 30 }
      print_asterisk
      exit
    end

    def dump(*args)
      print_asterisk
      args.each_with_index { |item, index| p 'param ' + (index + 1).to_s + ":"; p item; p '-' * 30 }
      print_asterisk
    end

    # grape 接口调用 成功 通用返回数据 格式
    def success_return(rdata = '', rcode = 200, rmsg = '操作成功')
      {
        code: rcode,
        msg: rmsg,
        data: rdata
      }
    end

    #grape 接口调用失败 ,通用返回数据 格式
    def error_return(rmsg = '操作失败', rcode = 400, rdata = '')
      {
        code: rcode,
        msg: rmsg,
        data: rdata
      }
    end

    # 抛出异常
    def raise_json(**args)
      raise_json = args.to_json
      raise raise_json
    end

    #  日志记录 错误的内容
    def logger_error(e = '')
      #如果当前不是生成环境,异常直接抛出,便于 查看 问题
      unless Rails.env.equal? 'production'
        raise e
      end
      asterisk = "*" * 30
      Rails.logger.debug " #{asterisk}\n exception is: #{e}\n"
    end
  end
end
