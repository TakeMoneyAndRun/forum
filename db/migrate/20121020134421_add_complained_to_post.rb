class AddComplainedToPost < ActiveRecord::Migration
  def change
    add_column :posts, :complained, :boolean, :default => false
  end
end
