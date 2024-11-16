class CreateLibraryUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :library_users do |t|
      t.boolean :is_admin, default: false
      t.references :user, null: false, foreign_key: true
      t.references :library, null: false, foreign_key: true

      t.timestamps
    end
  end
end
