class CreateFollowRecords < ActiveRecord::Migration[5.1]
  def change
    #跟进记录表
    create_table :follow_records do |t|
      t.datetime :arrange_time, comment: '安排时间'
      t.integer :follower_id, default: 0, comment: '跟进人ID,关联到 employees 员工表'
      t.integer :contact_id, default: 0, comment: '公司的联系人ID,关联到 contacts 公司联系人表'
      t.boolean :contact_information, comment: '联系方式 1.电话 2.邮件 3.会面 4.其他'
      t.string :followup_phase, limit: 20, comment: '跟进阶段 understand:了解客户需求及开通使用  send:发送资料 meet:见面 contract:确定方案合同 renew:续约电话 train:培训 other:其他  '
      t.text :remark, comment: '备注'
      t.boolean :followup_status, limit: 3, default: 0, comment: '跟进状态 1.已完成 '
      t.integer :company_id, default: 0, comment: '公司ID,关联到 companies 表'
      t.integer :delete_time, default: 0, comment: '删除时间 '
      t.timestamps null: true
    end
    #公司ID添加索引
    add_index :follow_records, :company_id
  end
end
