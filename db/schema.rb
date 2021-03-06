# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220528070423) do

  create_table "companies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "company_name", limit: 180, comment: "公司名称"
    t.string "company_phone", limit: 20, comment: "公司电话"
    t.string "company_postcode", limit: 30, comment: "公司邮编"
    t.string "company_address", comment: "公司地址"
    t.integer "followup_employee_id", default: 0, comment: "当前跟进的员工ID ,关联到 employees 表 "
    t.integer "delete_time", default: 0, comment: "删除时间"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followup_employee_id"], name: "index_companies_on_followup_employee_id", comment: "跟进员工ID"
  end

  create_table "contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", limit: 30, comment: "姓名"
    t.integer "sex", limit: 1, comment: "性别 1为男 2为女"
    t.string "department", limit: 30, comment: "部门"
    t.integer "importance", limit: 1, default: 0, comment: "重要性 1.重要 2.普通"
    t.string "mobile", comment: "手机号,可能有多个"
    t.string "phone", limit: 20, comment: "电话"
    t.string "email", limit: 30, comment: "邮箱"
    t.text "remark", comment: "备注"
    t.integer "delete_time", default: 0, comment: "删除时间"
    t.integer "company_id", default: 0, comment: "该联系人的公司ID,关联到 companies 表  "
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["company_id"], name: "index_contacts_on_company_id", comment: "公司ID"
  end

  create_table "employees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "employee_name", limit: 30, comment: "员工姓名"
    t.integer "delete_time", default: 0, comment: "删除时间"
    t.string "password_digest", comment: "密码加密后的字符串"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follow_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.datetime "arrange_time", comment: "安排时间"
    t.integer "follower_id", default: 0, comment: "跟进人ID,关联到 employees 员工表"
    t.integer "contact_id", default: 0, comment: "公司的联系人ID,关联到 contacts 公司联系人表"
    t.integer "contact_information", limit: 1, default: 0, comment: "联系方式 1.电话 2.邮件 3.会面 4.其他"
    t.string "followup_phase", limit: 30, default: "wait", comment: "跟进阶段,默认是wait  wait:等待跟进中  understand:了解客户需求及开通使用  send:发送资料 meet:见面 contract:确定方案合同 renew:续约电话 train:培训 other:其他  "
    t.text "remark", comment: "备注"
    t.integer "followup_status", limit: 1, default: 1, comment: "跟进状态 1.未完成 2.已完成 ,默认未完成 "
    t.integer "company_id", default: 0, comment: "公司ID,关联到 companies 表"
    t.integer "delete_time", default: 0, comment: "删除时间 "
    t.integer "create_user_id", default: 0, comment: "创建人ID,即当前用户"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["company_id"], name: "index_follow_records_on_company_id", comment: "公司ID"
    t.index ["follower_id"], name: "index_follow_records_on_follower_id", comment: "跟进人ID"
  end

end
