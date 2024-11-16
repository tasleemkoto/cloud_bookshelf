class AddUniqueIndexToBooksQrCode < ActiveRecord::Migration[7.1]
  def change
    add_index :books, :qr_code, unique: true
  end
end
