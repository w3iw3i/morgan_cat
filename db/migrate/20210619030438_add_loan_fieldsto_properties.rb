class AddLoanFieldstoProperties < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :start_ownership_year, :integer
    add_column :properties, :original_loan_amount, :integer
    add_column :properties, :loan_interest_annual, :float
    add_column :properties, :loan_tenure_years, :integer
  end
end
