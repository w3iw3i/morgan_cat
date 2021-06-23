class AddPostalcodeToProperties < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :postal_code, :string
  end
end
