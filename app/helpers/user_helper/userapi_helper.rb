module UserHelper
  module UserapiHelper
    #保存用户
    def save_user(user)
      #开启事务
      ActiveRecord::Base.transaction do
        #password 在数据库中 实际 不存在
        Employee.create!(employee_name: user[:employee_name], password: user[:password])
      end
    end

    #用户登录
    def login_user(params)
      employee = Employee.find_by(employee_name: params[:employee_name]).try(:authenticate, params[:password])
      unless employee
        raise_json msg: '抱歉,该用户不存在或密码错误,请重试'
      end
      { token: employee.token, employee_name:employee.employee_name }
    end
  end
end

