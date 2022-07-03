class AddLotsOfUsersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    1.times do |index|
      company = Company.new
      company.company_name = "公司#{index}"
      company.followup_employee_id = 1
      company.save
    end
  end
end
