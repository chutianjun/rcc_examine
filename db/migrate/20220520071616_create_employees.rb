class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    #公司员工表
    create_table :employees do |t|
      t.string :employee_name, limit: 30, comment: '员工姓名'
      t.integer :delete_time, default: 0, comment: '删除时间'
      t.timestamps null: true
    end
  end
end
