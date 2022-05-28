class ChangeColumnToCompaniesCompanyPostcode < ActiveRecord::Migration[5.1]
  def change
    change_column :companies, :company_postcode, :string, limit: 30, comment: '公司邮编'
  end
end
