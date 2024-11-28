class AddLibraryIdToWishlists < ActiveRecord::Migration[7.1]
  def change
    add_reference :wishlists, :library, null: false, foreign_key: true
  end
end
