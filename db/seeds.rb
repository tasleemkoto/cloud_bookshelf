# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# require 'faker'

# puts "Cleaning up database..."
# Book.destroy_all
# User.destroy_all
# Library.destroy_all
# puts "Database cleaned"



# puts "Creating libraries..."
# 10.times do
#   begin
#     Library.create!( name: Faker::Cannabis.unique.strain, unique_id: Faker::Alphanumeric.unique.alphanumeric(number: 10) )
#   rescue ActiveRecord::RecordInvalid => e
#     puts "Failed to create library: #{e.message}"
#     retry
#   end
# end

# puts "Seeded 10 libraries!"

#  # 5.times do
# #     puts "Creating books for library..."
# #     Book.create!(
# #       title: Faker::Book.title,
# #       summary: Faker::Lorem.sentence,
# #       author: Faker::Book.author,
# #       genre: Faker::Book.genre,
# #       year: rand(1900..Date.today.year),
# #       format: %w[ebook hardcover researchpaper].sample, # Random valid format
# #       availability: [true, false].sample,
# #       location: "Shelf #{rand(1..10)}",
# #       quantity: rand(1..5),
# #       #library: library,
# #       #user: default_user # Associate with the default user
# #     )
# #   end
# # end



# # Generate 10 users
# 10.times do
#   User.create!(
#     email: Faker::Internet.unique.email,
#     password: 'password', # Assuming you have a password field and it's required
#     password_confirmation: 'password', # Assuming you have password confirmation
#   )
# end

# puts "Seeded 10 users!"

# # Generate 10 books
# 10.times do
#   Book.create!(
#     title: Faker::Book.title,
#     summary: Faker::Lorem.paragraph,
#     author: Faker::Book.author,
#     genre: Faker::Book.genre,
#     year: Faker::Number.between(from: 1800, to: 2024),
#     format: ["hardcover", "researchpaper", "ebook"].sample,
#     availability: Faker::Boolean.boolean,
#     location: Faker::Address.city,
#     qr_code: Faker::Code.unique.asin,
#     photo: Faker::LoremFlickr.image(size: "300x400", search_terms: ['book']),
#     quantity: Faker::Number.between(from: 1, to: 10),
#     status: ["Available", "Checked Out"].sample,
#     view_count: Faker::Number.between(from: 0, to: 100),
#     user_id: User.ids.sample,
#     library_id: Library.ids.sample
#     )
#   end

# puts "Seeded 10 books!"
# puts "Seeding completed!"

require 'faker'

# Clear previous data
User.destroy_all
Library.destroy_all
Book.destroy_all
Checkout.destroy_all
Notification.destroy_all
Wishlist.destroy_all
Review.destroy_all

puts "Creating users..."

# CloudBookshelf Admin User
cloudbookshelf_admin = User.create!(
  email: 'cloudbookshelf_admin@cloudbookshelf.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: true  # Application-level admin
)

# Regular Users (can be added as library-specific admins)
librarian = User.create!(
  email: 'librarian@cloudbookshelf.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: false  # Not an application-wide admin
)

student = User.create!(
  email: 'student@cloudbookshelf.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: false
)

student_2 = User.create!(
  email: 'student2@cloudbookshelf.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: false
)

puts "Creating library..."

# Library created by the librarian (library-specific admin)
library = Library.create!(
  name: 'Central Library',
  unique_id: SecureRandom.uuid
)

# Assign librarian as library-specific admin
LibraryUser.create!(
  user: librarian,
  library: library,
  is_admin: true  # Admin for this specific library
)

# Grant access to students (non-admins)
LibraryUser.create!(user: student, library: library, is_admin: false)
LibraryUser.create!(user: student_2, library: library, is_admin: false)

puts "Library created and users added"

# Books, reviews, checkouts, notifications, etc.
5.times do
  book = Book.create!(
    title: Faker::Book.title,
    author: Faker::Book.author,
    genre: Faker::Book.genre,
    year: Faker::Number.between(from: 1900, to: Date.today.year),
    format: %w[ebook hardcover researchpaper].sample,
    library: library,
    user: librarian,
    qr_code: SecureRandom.uuid,
    quantity: Faker::Number.between(from: 1, to: 5)
  )

  # Librarian creates a review
  Review.create!(
    user: librarian,
    book: book,
    rating: Faker::Number.between(from: 3, to: 5),
    comment: Faker::Lorem.sentence
  )
end

puts "Books added to library and reviewed by librarian"

# Create a checkout for a student
Checkout.create!(
  user: student,
  book: library.books.sample,
  start_date: Date.today,
  due_date: Date.today + 7.days
)

puts "Checkout created for student"

# Notifications, wishlist, and additional student actions
Notification.create!(
  user: student,
  content: 'New books available!'
)

Wishlist.create!(
  user: student,
  book: library.books.first
)

Review.create!(
  user: student,
  book: library.books.first,
  rating: 4,
  comment: "Excellent resource!"
)

puts "Seed data loaded successfully!"