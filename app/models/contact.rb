class Contact < ApplicationRecord
  #联系人 从属 于公司
  belongs_to :company, -> { select(:id, :company_name) }, class_name: 'Company', foreign_key: 'company_id'

  # 默认scope
  default_scope { where(delete_time: 0) }
end
