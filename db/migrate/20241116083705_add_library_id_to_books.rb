class AddLibraryIdToBooks < ActiveRecord::Migration[7.1]
  def change
    add_reference :books, :library, null: false, foreign_key: true
  end
end
