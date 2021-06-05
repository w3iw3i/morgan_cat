class AddColumnToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :year, :date
  end
end
