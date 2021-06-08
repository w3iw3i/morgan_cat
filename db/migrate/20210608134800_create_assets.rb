class CreateAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :assets do |t|
      t.string :asset_type
      t.integer :amount
      t.float :growth_rate
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
