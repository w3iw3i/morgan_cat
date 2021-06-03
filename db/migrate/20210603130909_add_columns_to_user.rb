class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :dob, :date
    add_column :users, :monthly_savings, :integer
    add_column :users, :monthly_income, :integer
    add_column :users, :monthly_expenses, :integer
    add_column :users, :target_retirement_age, :integer
    add_column :users, :default_inflation_rate, :integer
  end
end
