class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :address
      t.string :floor
      t.string :unit
      t.string :flat_type
      t.integer :area
      t.integer :lease_remaining
      t.references :user, null: false, foreign_key: true
      t.float :property_growth_rate
      t.integer :property_value

      t.timestamps
    end
  end
end
