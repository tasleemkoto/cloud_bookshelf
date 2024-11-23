class CreateCheckoutBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :checkout_books do |t|
      t.references :checkout, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.date :start_date
      t.date :due_date

      t.timestamps
    end
  end
end
