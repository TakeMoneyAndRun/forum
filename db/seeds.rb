# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Role.create([{:name  => :admin},{:name  => :moderator}, {:name  => :user}])
User.create(email: 'admin@admin.ad', nickname: 'Admin', password: 'adminn', password_confirmation: 'adminn')
UsersRole.create(user_id: 1, role_id: 1)
