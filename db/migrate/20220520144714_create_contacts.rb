class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    #公司 联系人表
    create_table :contacts do |t|
      t.string :name, limit: 30, comment: '姓名'
      t.boolean :sex, limit: 3, comment: '性别 1为男 2为女'
      t.string :department, limit: 30, comment: '部门'
      t.boolean :importance, limit: 3, comment: '重要性 1.重要 2.普通'
      t.string :mobile, comment: '手机号,可能有多个'
      t.string :phone, limit: 20, comment: '电话'
      t.string :email, limit: 30, comment: '邮箱'
      t.text :remark, comment: '备注'
      t.integer :delete_time, default: 0, comment: '删除时间'
      t.integer :company_id, default: 0, comment: '该联系人的公司ID,关联到 companies 表  '
      t.timestamps null: true
    end
    #公司ID添加索引
    add_index :contacts, :company_id
  end
end
