class Employee < ApplicationRecord
  # has_many :companys, class_name: 'Company'
  # 默认scope
  default_scope { where(delete_time: 0) }
end
