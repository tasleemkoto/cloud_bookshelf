require 'faker'
require 'open-uri'
require 'cloudinary'

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

# Fetch assets from Cloudinary
def fetch_cloudinary_assets(folder)
  resources = Cloudinary::Api.resources(
    type: :upload,
    prefix: folder,
    max_results: 100
  )
  resources['resources'].map { |resource| resource['secure_url'] }
rescue Cloudinary::Api::Error => e
  puts "Cloudinary API Error: #{e.message}"
  []
end

puts "Fetching assets from Cloudinary..."
cloudinary_photos = fetch_cloudinary_assets('Bookshelf').select { |url| url.match?(/\.(jpg|jpeg|png)$/i) }

if cloudinary_photos.empty?
  raise "No photos found in Cloudinary folder 'Bookshelf'. Please upload book images."
end

# Predefined PDF URL
pdf_url = 'https://res.cloudinary.com/dnaxhzf4d/image/upload/v1734113615/sample_ebook_fllzxe.pdf'

puts "Adding books..."
20.times do
  format = %w[ebook hardcover researchpaper].sample
  quantity = format == 'hardcover' ? rand(1..5) : nil
  qr_code = format == 'hardcover' ? SecureRandom.uuid : nil

  book = Book.new(
    title: Faker::Book.title,
    summary: Faker::Lorem.paragraph,
    author: Faker::Book.author,
    genre: Faker::Book.genre,
    year: rand(1900..Date.today.year),
    format: format,
    library: library_1,
    user: librarian,
    quantity: quantity,
    qr_code: qr_code
  )

  begin
    # Attach a random Cloudinary photo
    photo_url = cloudinary_photos.sample
    downloaded_photo = URI.open(photo_url)
    book.photo.attach(
      io: downloaded_photo,
      filename: File.basename(photo_url),
      content_type: downloaded_photo.content_type
    )
    puts "Photo attached for book: #{book.title}"

    # Attach the predefined PDF for eBooks
    if format == 'ebook'
      downloaded_pdf = URI.open(pdf_url)
      book.pdf.attach(
        io: downloaded_pdf,
        filename: 'sample_ebook.pdf',
        content_type: 'application/pdf'
      )
      puts "PDF attached for eBook: #{book.title}"
    end

    book.save!
    puts "Book created: #{book.title}, Format: #{book.format}"

    # Add reviews
    [student_1, student_2].each do |student|
      Review.create!(user: student, book: book, rating: rand(1..5), comment: Faker::Lorem.sentence)
    end

    # Add to wishlist
    Wishlist.create!(user: student_1, book: book, library: library_1)

  rescue OpenURI::HTTPError => e
    puts "Failed to attach asset for book '#{book.title}': #{e.message}"
  end
end

puts "Books added: #{Book.count}, Reviews added: #{Review.count}, Wishlists created: #{Wishlist.count}"

# Create checkouts for hardcopy books
puts "Creating checkouts..."
library_1.books.where(format: 'hardcover').each do |book|
  next unless book.quantity.positive?

  Checkout.create!(
    user: student_1,
    book: book,
    library: library_1,
    start_date: Date.today,
    due_date: Date.today + 7.days,
    status: 'pending'
  )
  puts "Checkout created for book: #{book.title}"
end

puts "Checkouts created: #{Checkout.count}"

# Create notifications
puts "Creating notifications..."
Notification.create!(user: student_1, library: library_1, content: 'New books are now available in Central Library!')
Notification.create!(user: librarian, library: library_1, content: 'Please review the latest reservations.')

puts "Notifications created: #{Notification.count}"
puts "Seed data loaded successfully!"






