# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 初始化数据库

dbhandle = ActiveRecord::Base.connection
curr_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
# 员工相关
employees = [
  { employee_name: '张曼迪' },
  { employee_name: '李小刚' },
  { employee_name: '王小明' },
  { employee_name: '周小伟' },
  { employee_name: '刘晓红' },
  { employee_name: '胡小军' },
  { employee_name: '钱晓丽' },
  { employee_name: '左晓慧' },
  { employee_name: '彭晓宇' },
]
employee_params = []
employees.each do |item|
  employee_params.push("('#{item[:employee_name]}','#{curr_time}','#{curr_time}')")
end
employee_sql = "INSERT INTO employees (employee_name,created_at,updated_at) VALUES #{employee_params.join(", ")}"
dbhandle.insert employee_sql

#
# 公司相关
company_info = [
  { company_name: '北京瑞达恒建筑自咨询有限公司', company_phone: '010-27645688', company_postcode: '10001', company_address: '北京市海淀区西二旗', followup_employee_id: 1 },
  { company_name: '上海凌放新高设计咨询有限公司', company_phone: '010-27645687', company_postcode: '10300', company_address: '上海市浦东新区世纪大道', followup_employee_id: 2 },
  { company_name: '北京朝阳长虹', company_phone: '010-27645689', company_postcode: '10800', company_address: '北京市朝阳区芍药居', followup_employee_id: 3 },
  { company_name: '深圳互火科技有限公司', company_phone: '010-27645688', company_postcode: '10800', company_address: '深圳市南山区深南大道', followup_employee_id: 4 },
  { company_name: '北京创生活建筑咨询有限公司', company_phone: '010-27625688', company_postcode: '10090', company_address: '北京市朝阳区芍药居', followup_employee_id: 5 },
  { company_name: '上海浦东远航发展有限公司', company_phone: '010-27645688', company_postcode: '10010', company_address: '深圳市南山区深南大道', followup_employee_id: 6 },
  { company_name: '北京神罗商贸有限公司', company_phone: '010-27655688', company_postcode: '16000', company_address: '上海市浦东新区世纪大道', followup_employee_id: 7 },
  { company_name: '深圳南山装饰有限公司', company_phone: '010-27945688', company_postcode: '10300', company_address: '北京市朝阳区芍药居', followup_employee_id: 8 },
  { company_name: '北京永陵新材料有限公司', company_phone: '010-87645688', company_postcode: '10600', company_address: '深圳市南山区深南大道', followup_employee_id: 9 },
  { company_name: '广州市五象洗涤机械有限公司', company_phone: '010-57645688', company_postcode: '10700', company_address: '北京市西城区西二旗', followup_employee_id: 1 },
]

company_params = []
company_info.each do |item|
  company_params.push("('#{item[:company_name]}','#{item[:company_phone]}','#{item[:company_postcode]}','#{item[:company_address]}','#{item[:followup_employee_id]}','#{curr_time}','#{curr_time}')")
end
company_sql = "INSERT INTO companies (company_name,company_phone,company_postcode,company_address,followup_employee_id,created_at,updated_at)VALUES #{company_params.join(", ")}"
dbhandle.insert company_sql

#公司联系人相关数据
company_contact_info = [
  { name: '徐思', sex: '2', department: '市场部', importance: '1', mobile: '18172877866,13898545875', phone: '0791-8755458', email: '807035@qq.com', company_id: 1 },
  { name: '刘志丹', sex: '2', department: '销售部', importance: '2', mobile: '18162877866,13888545875', phone: '0792-8755458', email: '307035@qq.com', company_id: 1 },
]

contact_params = []
company_contact_info.each do |item|
  contact_params.push("('#{item[:name]}','#{item[:sex]}','#{item[:department]}','#{item[:importance]}','#{item[:mobile]}','#{item[:phone]}','#{item[:email]}','#{item[:company_id]}','#{curr_time}','#{curr_time}')")
end
company_contact_sql = "INSERT INTO contacts (`name`, `sex`, `department`, `importance`, `mobile`, `phone`, `email`, `company_id`, `created_at`, `updated_at`) VALUES #{contact_params.join(", ")}"
dbhandle.insert company_contact_sql

#公司跟进记录相关数据
company_follow_record = [
  {
    arrange_time: '2022-05-19 12:01:17',
    follower_id: 1,
    contact_id: 1,
    contact_information: 1,
    followup_phase: 'understand',
    remark: '和徐总确认一下下次见面时间',
    followup_status:1,
    company_id: 1,
    create_user_id: 1
  },
  {
    arrange_time: '2022-05-20 12:01:17',
    follower_id: 1,
    contact_id: 1,
    contact_information: 1,
    followup_phase: 'send',
    remark: '发送资料过去',
    followup_status:1,
    company_id: 1,
    create_user_id: 1
  },
]

follow_params = []
company_follow_record.each do |item|
  follow_params.push("('#{item[:arrange_time]}','#{item[:follower_id]}','#{item[:contact_id]}','#{item[:contact_information]}','#{item[:followup_phase]}','#{item[:remark]}','#{item[:followup_status]}','#{item[:company_id]}','#{item[:create_user_id]}','#{curr_time}','#{curr_time}')")
end
company_follow_record_sql = "INSERT INTO follow_records (arrange_time,
follower_id,
contact_id,
contact_information,
followup_phase,
remark,
followup_status,
company_id,
create_user_id,
created_at,
updated_at
) VALUES #{follow_params.join(", ")}"
dbhandle.insert company_follow_record_sql