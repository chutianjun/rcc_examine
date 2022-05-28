class ChangeColumnToCompaniesCompanyPostcode < ActiveRecord::Migration[5.1]
  def change
    change_column :companies, :company_postcode, limit: 30
  end
end
