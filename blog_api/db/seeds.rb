# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

BLOG_COUNT = 20
USER_COUNT = 15
COMMENT_COUNT = 50

#creating roles
# Role.create!(
#   name: "Admin",
#   value: 1
# );

# Role.create!(
#   name: "Manager",
#   value: 2
# );

# Role.create!(
#   name: "User",
#   value: 3
# );

# puts "3 roles created."

# clearing the existing data
# User.delete_all
# ActiveRecord::Base.connection.execute("TRUNCATE TABLE users")

# User.create!(
#   name: 'Admin Gyi',
#   email: 'admin@gmail.com',
#   password: 'password',
#   password_confirmation: 'password',
#   role_value: 1,
#   isBanned: 0,
#   bannedPeriod: 0
# );

# users = USER_COUNT.times.map do
#   User.create!(
#     name: Faker::Name.name,
#     email: Faker::Internet.email,
#     password: 'password',
#     password_confirmation: 'password',
#     role_value: rand(1..3),
#   )
# end

# puts "#{USER_COUNT} user accounts created..."

# Blog.delete_all
# ActiveRecord::Base.connection.execute("TRUNCATE TABLE blogs")

# blogs = BLOG_COUNT.times.map do
#   Blog.create!(
#     title: Faker::Book.title,
#     content: Faker::Lorem.paragraphs(number: 15).join("\n\n"),
#     user: users.sample
#   )
# end


# puts "#{BLOG_COUNT} blog post created..."

# Comment.delete all records
# ActiveRecord::Base.connection.execute("TRUNCATE TABLE comments")

COMMENT_COUNT.times do
  Comment.create!(
    comment: Faker::Lorem.paragraph,
    user_id: rand(1..16),
    blog_id: rand(1..20)
  )
end

puts "comments created randomly"