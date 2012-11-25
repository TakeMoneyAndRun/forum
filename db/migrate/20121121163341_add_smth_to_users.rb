class AddSmthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :nickname, :string
    add_column :users, :rating, :integer
  end
end
