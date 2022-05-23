class Contact < ApplicationRecord
  validates :name, presence: { message: "联系人姓名不能为空" }
  validates :mobile, presence: { message: "联系人手机号不能为空" }
  validates :company_id, presence: { message: "联系人公司不能为空" }, numericality: { greater_than: 0, message: "联系人公司数据错误" }

  #联系人 从属 于公司
  belongs_to :company, -> { select(:id, :company_name) }, class_name: 'Company', foreign_key: 'company_id'

  # 默认scope
  default_scope { where(delete_time: 0) }
end
