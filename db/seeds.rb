# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create!(name: "Sojourner House", address: "85 Rockland St, Roxbury MA, 02119", phone: "(617) 442-0590", password: 'test', password_confirmation: 'test', full: false)

User.create!(name: "St Francis House", address: "39 Boylston St, Boston MA, 02116", phone: "(617) 542-4211", password: 'test', password_confirmation: 'test', full: false)

User.create!(name: "Sojourner House", address: "889 Harrison Ave, Boston MA, 02118", phone: "(617) 442-9322", password: 'test', password_confirmation: 'test', full: false)

User.create!(name: "Full House", address: "889 Harrison Ave, Boston MA, 02118", phone: "(617) 442-9322", password: 'test', password_confirmation: 'test', full: true)
