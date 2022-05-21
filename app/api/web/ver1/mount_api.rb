module Web
  module Ver1
    #v1 版本所有api 接口的 总 挂载类
    class MountAPI < Grape::API
      version 'v1', using: :path

      #挂载 公司 相关的接口
      mount Companys::CompanyAPI

    end
  end
end
