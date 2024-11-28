class AddLibraryIdToCheckouts < ActiveRecord::Migration[7.1]
  def change
    add_reference :checkouts, :library, null: false, foreign_key: true
  end
end
