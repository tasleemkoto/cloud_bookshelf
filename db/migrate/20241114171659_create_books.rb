class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :summary
      t.string :author
      t.string :genre
      t.integer :year
      t.string :format
      t.boolean :availability, default: true
      t.string :location
      t.string :qr_code
      t.string :photo
      t.integer :quantity
      t.string :status
      t.integer :view_count, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
