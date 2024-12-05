class RemoveUserIdFromLibraries < ActiveRecord::Migration[7.1]
  def change
    change_column_default :libraries, :user_id, nil
  end
end
