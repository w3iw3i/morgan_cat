class ChangeYeartoInteger < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :year_int, :integer
  end
end
