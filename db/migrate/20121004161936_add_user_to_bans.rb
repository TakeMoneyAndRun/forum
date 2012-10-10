class AddUserToBans < ActiveRecord::Migration
  def change
    add_column :bans, :user_id, :integer
  end
end
