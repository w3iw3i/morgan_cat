# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Asset.destroy_all

Asset.create(asset_type: "cash", amount: 10000, growth_rate: -1.5, user_id:1, asset_allocation: 60)
Asset.create(asset_type: "stocks", amount: 10000, growth_rate: 8, user_id:1, asset_allocation: 10)
Asset.create(asset_type: "bonds", amount: 2000, growth_rate: 2, user_id:1, asset_allocation: 10)
Asset.create(asset_type: "cpfo", amount: 2000, growth_rate: 4, user_id:1, asset_allocation: 15)
Asset.create(asset_type: "cpfs", amount: 1000, growth_rate: 4, user_id:1, asset_allocation: 3)
Asset.create(asset_type: "cpfm", amount: 1000, growth_rate: 4, user_id:1, asset_allocation: 2)

