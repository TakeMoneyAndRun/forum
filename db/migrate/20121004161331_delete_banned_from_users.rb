class DeleteBannedFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :banned
  end

  def down
    remove_column :users, :banned
  end
end
