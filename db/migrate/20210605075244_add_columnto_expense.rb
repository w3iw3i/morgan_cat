class AddColumntoExpense < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :inflated_amt, :integer
  end
end
