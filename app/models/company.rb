class Company < ApplicationRecord
  attr_accessor :follow_up_employee_name
  #  公司当前的跟进人,只有一个
  belongs_to :follow_up_employee, -> { select(:id, :employee_name) }, class_name: 'Employee', foreign_key: 'followup_employee_id'
  # 默认scope
  default_scope { where(delete_time: 0) }
  #公司的联系人有多个
  has_many :contacts, -> { select(:id, :name, :mobile, :phone, :email, :importance, :department, :sex) }, class_name: 'Contact', foreign_key: 'company_id'
end
