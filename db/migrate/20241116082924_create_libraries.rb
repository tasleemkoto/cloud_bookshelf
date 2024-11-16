class CreateLibraries < ActiveRecord::Migration[7.1]
  def change
    create_table :libraries do |t|
      t.string :name, null: false
      t.string :unique_id, null: false

      t.timestamps
    end
    add_index :libraries, :unique_id, unique: true
  end
end
