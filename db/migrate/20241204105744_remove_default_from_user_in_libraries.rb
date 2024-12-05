class RemoveDefaultFromUserInLibraries < ActiveRecord::Migration[7.1]
  def change
    change_column_default :libraries, :user_id, from: User.first.id, to: nil
  end
end
