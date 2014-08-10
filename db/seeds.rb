# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "Sojourner House", email: 'soj@test.org', address: "85 Rockland St, Roxbury MA, 02119", phone: "(617) 442-0590", password: 'test1234', password_confirmation: 'test1234', size: 10, full: false)

User.create!(name: "St Francis House", email: 'stf@test.org', address: "39 Boylston St, Boston MA, 02116", phone: "(617) 542-4211", password: 'test1234', password_confirmation: 'test1234', size: 15, full: false)

User.create!(name: "Helter Shelter", email: 'bla@test.org', address: "889 Harrison Ave, Boston MA, 02118", phone: "(617) 442-9322", password: 'test1234', password_confirmation: 'test1234', size: 3, full: false)

User.create!(name: "Full House", email: 'cra@test.org', address: "20 Columbus Ave, Boston MA, 02118", phone: "(617) 442-9322", password: 'test1234', password_confirmation: 'test1234', size: 100, full: true)

User.create!(name: "Home", email: 'sdj@test.org', address: "1 Broadway, Cambridge, MA", phone: "(617) 442-0590", password: 'test1234', password_confirmation: 'test1234', size: 100, full: false)

User.create!(name: "Battlehack", email: 'srr@test.org', address: "South Station, Boston, MA", phone: "(617) 542-4211", password: 'test1234', password_confirmation: 'test1234', size: 12, full: false)

User.create!(name: "Hailey House", email: 'asd@test.org', address: "1 Prinec St., Boston MA, 02118", phone: "(617) 442-9322", password: 'test1234', password_confirmation: 'test1234', size: 20, full: false)

User.create!(name: "Serenity", email: 'xas@test.org', address: "Space", phone: "(617) 442-9322", password: 'test1234', password_confirmation: 'test1234', size: 15, full: true)

