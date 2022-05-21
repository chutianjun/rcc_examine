class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    # 公司表
    create_table :companies do |t|
      t.string :company_name, limit: 180, comment: '公司名称'
      t.string :company_phone, limit: 20, comment: '公司电话'
      t.string :company_postcode, limit: 10, comment: '公司邮编'
      t.string :company_address, limit: 255, comment: '公司地址'
      t.integer :followup_employee_id, default: 0, comment: '当前跟进的员工ID ,关联到 employees 表 '
      t.integer :delete_time, default: 0, comment: '删除时间'
      t.timestamps null: true
    end
    #员工ID添加索引
    add_index :companies, :followup_employee_id
  end
end
