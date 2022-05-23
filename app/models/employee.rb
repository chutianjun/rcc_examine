class Employee < ApplicationRecord
  has_secure_password

  has_many :companys, -> { select(:id, :company_name, :company_phone) }, class_name: 'Company', foreign_key: 'followup_employee_id'
  # 默认scope
  default_scope { where(delete_time: 0) }

  #将 用户ID, 用户密码信息 加入到 token的 payload 信息中
  def token
    Token.encode(user_id: self.id, user_password: self.password_digest)
  end
end
