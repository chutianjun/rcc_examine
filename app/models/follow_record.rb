class FollowRecord < ApplicationRecord
  validates :arrange_time, presence: { message: "安排时间不能为空" }
  validates :follower_id, presence: { message: "跟进人不能为空" }, numericality: { greater_than: 0, message: "跟进人数据错误" }
  validates :contact_id, presence: { message: "联系人不能为空" }, numericality: { greater_than: 0, message: "联系人数据错误" }
  validates :contact_information, presence: { message: "联系方式不能为空" }
  validates :followup_phase, presence: { message: "跟进阶段不能为空" }
  validates :company_id, presence: { message: "跟进公司信息不能为空" }
  validates :followup_status, presence: { message: "跟进状态不能为空" }
  #更新才需要id
  validates :id, presence: { message: "id不能为空" }, on: :update

  # 默认scope
  default_scope { where(delete_time: 0) }
  # 跟进人 相关 数据
  belongs_to :follow_user, -> { select(:id, :employee_name) }, class_name: 'Employee', foreign_key: 'follower_id'
  #  联系人相关数据
  belongs_to :contact, -> { select(:id, :name) }, class_name: 'Contact', foreign_key: 'contact_id'
  #  创建人相关数据
  belongs_to :create_user, -> { select(:id, :employee_name) }, class_name: 'Employee', foreign_key: 'create_user_id'


  #写一条SQL语句查询出跟进任务列表需要的数据。(写在跟进任务model类中)
  def self.get_follow_list_data
    ::Company.find_by_sql('SELECT
	companies.id,
	companies.company_name,
	companies.company_phone,
	companies.company_postcode,
	companies.company_address,
	follow_records.arrange_time,
follow_records.follower_id,
follow_records.contact_id,
follow_records.contact_information,
follow_records.followup_phase,
follow_records.remark,
follow_records.followup_status,
follow_records.company_id,
follow_records.delete_time,
follow_records.create_user_id,
follow_records.created_at
FROM
	companies
	LEFT JOIN follow_records ON companies.id = follow_records.company_id
	WHERE companies.id=1
')
  end
end
