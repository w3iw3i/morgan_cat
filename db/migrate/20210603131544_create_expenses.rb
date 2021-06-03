class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :expense_type
      t.integer :amount
      t.timestamps
    end
  end
end
