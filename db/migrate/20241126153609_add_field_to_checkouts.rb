class AddFieldToCheckouts < ActiveRecord::Migration[7.1]
  def change
    add_column :checkouts, :status, :integer, default: 0
  end
end
