require 'faker'
require 'cloudinary'
require 'open-uri'

# Clear old data
puts "Clearing old data..."
[Review, Wishlist, Notification, Checkout, Book, LibraryUser, Library, User].each(&:destroy_all)
puts "All data cleared!"

# Create users
puts "Creating users..."
admin = User.create!(email: 'admin@cloudbookshelf.com', password: 'password123', admin: true)
librarian = User.create!(email: 'librarian@cloudbookshelf.com', password: 'password123')
student_1 = User.create!(email: 'student1@cloudbookshelf.com', password: 'password123')
student_2 = User.create!(email: 'student2@cloudbookshelf.com', password: 'password123')

puts "Users created: #{User.count}"

# Create libraries
puts "Creating libraries..."
library_1 = Library.create!(name: 'Central Library', user: admin)
library_2 = Library.create!(name: 'Science Library', user: librarian)

puts "Libraries created: #{Library.count}"

# Assign users to libraries
puts "Assigning users to libraries..."
LibraryUser.create!(user: librarian, library: library_1, is_admin: true)
LibraryUser.create!(user: student_1, library: library_1)
LibraryUser.create!(user: student_2, library: library_1)
LibraryUser.create!(user: librarian, library: library_2, is_admin: true)

puts "Library users assigned: #{LibraryUser.count}"

# Add books to libraries
puts "Adding books to libraries..."

# Fetch images from a Cloudinary folder
def fetch_cloudinary_images(folder)
  resources = Cloudinary::Api.resources(
    type: :upload,
    prefix: folder,
    max_results: 100 # Adjust the max number as needed
  )
  resources['resources'].map { |resource| resource['secure_url'] }
rescue Cloudinary::Api::Error => e
  Rails.logger.error "Cloudinary API Error: #{e.message}"
  []
end

# Example: Fetch images from a specific folder in Cloudinary
cloudinary_images = fetch_cloudinary_images('books')

# Ensure there are enough images for the books
if cloudinary_images.size < 16
  raise "Not enough images in Cloudinary folder! Found #{cloudinary_images.size}, need at least 20."
end

# Create books with Cloudinary images
cloudinary_images.shuffle! # Shuffle to assign randomly

16.times do
  format = %w[ebook hardcover researchpaper].sample
  quantity = format == 'hardcover' ? rand(2..5) : 1

  # Create a book
  book = Book.create!(
    title: Faker::Book.title,
    summary: Faker::Lorem.paragraph,
    author: Faker::Book.author,
    genre: Faker::Book.genre,
    year: rand(1900..Date.today.year),
    format: format,
    library: library_1,
    user: librarian,
    quantity: quantity
  )

  # Attach a unique Cloudinary photo
  photo_url = cloudinary_images.pop # Get and remove the last image from the array
  downloaded_photo = URI.open(photo_url)
  book.photo.attach(
    io: downloaded_photo,
    filename: File.basename(photo_url),
    content_type: 'image/jpeg' # Adjust content type based on the file
  )

  puts "Book created: #{book.title} (ID: #{book.id}, Quantity: #{book.quantity}, Format: #{book.format}, Photo: #{photo_url})"

  # Add reviews
  [student_1, student_2].each do |student|
    Review.create!(user: student, book: book, rating: rand(1..5), comment: Faker::Lorem.sentence)
  end

  # Add to wishlist
  Wishlist.create!(user: student_1, book: book, library: library_1)
end

puts "Books added: #{Book.count}, Reviews added: #{Review.count}, Wishlists created: #{Wishlist.count}"

# Create checkouts for hardcopy books
puts "Creating checkouts..."
library_1.books.where(format: 'hardcover').each do |book|
  if book.quantity > 0
    Checkout.create!(
      user: student_1,
      book: book,
      library: library_1,
      start_date: Date.today,
      due_date: Date.today + 7.days,
      status: 'pending'
    )
    puts "Checkout created for book: #{book.title} (Remaining quantity: #{[book.quantity - 1, 0].max})"
  end
end

puts "Checkouts created: #{Checkout.count}"

# Create notifications
puts "Creating notifications..."
Notification.create!(user: student_1, library: library_1, content: 'New books are now available in Central Library!')
Notification.create!(user: librarian, library: library_1, content: 'Please review the latest reservations.')

puts "Notifications created: #{Notification.count}"

puts "Seed data loaded successfully!"
