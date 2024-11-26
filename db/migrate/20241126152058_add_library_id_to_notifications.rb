class AddLibraryIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :library, null: false, foreign_key: true
  end
end
