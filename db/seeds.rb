# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Asset.destroy_all

Asset.create(asset_type: "Cash", amount: 10000, growth_rate: -1.5, user_id:1, asset_allocation: 60)
Asset.create(asset_type: "Stock", amount: 10000, growth_rate: 8, user_id:1, asset_allocation: 10)
Asset.create(asset_type: "Bond", amount: 2000, growth_rate: 2, user_id:1, asset_allocation: 10)
Asset.create(asset_type: "CPF-O", amount: 2000, growth_rate: 4, user_id:1, asset_allocation: 15)
Asset.create(asset_type: "CPF-S", amount: 1000, growth_rate: 4, user_id:1, asset_allocation: 3)
Asset.create(asset_type: "CPF-M", amount: 1000, growth_rate: 4, user_id:1, asset_allocation: 2)

Asset.create(asset_type: "Cash", amount: 10000, growth_rate: -1.5, user_id:2, asset_allocation: 60)
Asset.create(asset_type: "Stock", amount: 10000, growth_rate: 8, user_id:2, asset_allocation: 10)
Asset.create(asset_type: "Bond", amount: 2000, growth_rate: 2, user_id:2, asset_allocation: 10)
Asset.create(asset_type: "CPF-O", amount: 2000, growth_rate: 4, user_id:2, asset_allocation: 15)
Asset.create(asset_type: "CPF-S", amount: 1000, growth_rate: 4, user_id:2, asset_allocation: 3)
Asset.create(asset_type: "CPF-M", amount: 1000, growth_rate: 4, user_id:2, asset_allocation: 2)




