module Web
  class WebControlAPI < Grape::API
    #json格式化
    format :json
    #公共的helper方法
    helpers ::CommonHelper::CommonapiHelper
    #所有 v1  版本接口 的挂载 入口
    mount Ver1::MountAPI


  end
end