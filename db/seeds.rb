# THIS FILE SHOULD ENSURE THE EXISTENCE OF RECORDS REQUIRED TO RUN THE APPLICATION IN EVERY ENVIRONMENT (PRODUCTION,
# DEVELOPMENT, TEST). THE CODE HERE SHOULD BE IDEMPOTENT SO THAT IT CAN BE EXECUTED AT ANY POINT IN EVERY ENVIRONMENT.
# THE DATA CAN THEN BE LOADED WITH THE BIN/RAILS DB:SEED COMMAND (OR CREATED ALONGSIDE THE DATABASE WITH DB:SETUP).
#
# EXAMPLE:
#
#   ["ACTION", "COMEDY", "DRAMA", "HORROR"].EACH DO |GENRE_NAME|
#     MOVIEGENRE.FIND_OR_CREATE_BY!(NAME: GENRE_NAME)
#   END

require 'faker'

puts "Cleaning up database..."
Book.update_all(library_id: nil) # Remove library associations
Book.destroy_all
Library.destroy_all
User.destroy_all
puts "Database cleaned"

puts "Creating libraries..."
10.times do
  begin
    Library.create!( name: Faker::Cannabis.unique.strain, unique_id: Faker::Alphanumeric.unique.alphanumeric(number: 10) )
  rescue ActiveRecord::RecordInvalid => e
    puts "Failed to create library: #{e.message}"
    retry
  end
end



puts "Seeded 10 libraries!"

 # 5.times do
#     puts "Creating books for library..."
#     Book.create!(
#       title: Faker::Book.title,
#       summary: Faker::Lorem.sentence,
#       author: Faker::Book.author,
#       genre: Faker::Book.genre,
#       year: rand(1900..Date.today.year),
#       format: %w[ebook hardcover researchpaper].sample, # Random valid format
#       availability: [true, false].sample,
#       location: "Shelf #{rand(1..10)}",
#       quantity: rand(1..5),
#       #library: library,
#       #user: default_user # Associate with the default user
#     )
#   end
# end

# Generate 10 users
10.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: 'password', # Assuming you have a password field and it's required
    password_confirmation: 'password', # Assuming you have password confirmation
  )
end

puts "Seeded 10 users!"

# Generate 10 books
10.times do
  Book.create!(
    title: Faker::Book.title,
    summary: Faker::Lorem.paragraph,
    author: Faker::Book.author,
    genre: Faker::Book.genre,
    year: Faker::Number.between(from: 1800, to: 2024),
    format: ["hardcover", "researchpaper", "ebook"].sample,
    availability: Faker::Boolean.boolean,
    location: Faker::Address.city,
    qr_code: Faker::Code.unique.asin,
    photo: Faker::LoremFlickr.image(size: "300x400", search_terms: ['book']),
    quantity: Faker::Number.between(from: 1, to: 10),
    status: ["Available", "Checked Out"].sample,
    view_count: Faker::Number.between(from: 0, to: 100),
    user_id: User.ids.sample,
    library_id: Library.ids.sample
    )
end

puts "Seeded 10 books!"
puts "Seeding completed!"
