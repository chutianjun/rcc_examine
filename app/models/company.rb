class Company < ApplicationRecord
  attr_accessor :follow_up_employee_name
  validates :company_name, presence: { message: "抱歉,公司名称不能为空,请仔细检查" }
  #更新公司需要id
  validates :id, presence: { message: "id不能为空" }, on: :update

  #  公司当前的跟进人
  belongs_to :follow_up_employee, -> { select(:id, :employee_name) }, class_name: 'Employee', foreign_key: 'followup_employee_id'

  # 默认scope
  default_scope { where(delete_time: 0) }
  #公司的联系人有多个
  has_many :contacts, -> { select(:id, :name, :mobile, :phone, :email, :importance, :department, :sex, :company_id) }, class_name: 'Contact', foreign_key: 'company_id', dependent: :delete_all
  #公司的跟进记录 也有 多个
  has_many :follow_records, -> { select(:id, :arrange_time, :follower_id, :created_at, :create_user_id, :contact_id, :contact_information, :followup_phase, :remark, :company_id) }, class_name: 'FollowRecord', foreign_key: 'company_id', dependent: :delete_all

  #获取公司分页列表数据
  def self.get_company_list(params)
    #搜索公司,此处 includes 避免 n+1
    company_search = self.select(:id, :company_name, :company_phone, :company_postcode, :company_address, :followup_employee_id).includes(:follow_up_employee)
    #公司名称搜索
    company_search.where!('company_name like ? ', "%#{params[:company_name]}%") if params[:company_name].present?
    #跟进员工ID搜索
    company_search.where!(followup_employee_id: params[:followup_employee_id]) if params[:followup_employee_id] > 0
    #公司总数,排除掉 一些 关联,获取 总数
    company_total=company_search.except(:includes).count('id')
    #当前所在页数
    params[:page] ||= 1
    #每页条数
    params[:per_page] ||= 10
    offset_current = params[:page] - 1
    offset_current = (offset_current < 0) ? 0 : offset_current
    offset_size = offset_current * params[:per_page]
    database_data = company_search.limit!(params[:per_page]).offset!(offset_size)
    { company_total: company_total, database_data: database_data }
  end


  #写SQL查询出没有跟进任务的公司。(写在公司model类中)
  def self.no_follow_up_tasks
#     no_follow_companys=self.find_by_sql("SELECT a.id,a.company_name,a.company_phone,a.company_postcode,a.company_address FROM `companies` a left join follow_records  b on a.id=b.company_id
# WHERE ISNULL(b.id)")
    #
    no_follow_companys=self.select('companies.id,companies.company_name,companies.company_phone,companies.company_postcode,companies.company_address')
                           .joins(" left join follow_records   on companies.id=follow_records.company_id")
                           .where("ISNULL(follow_records.id)")

  end
end
