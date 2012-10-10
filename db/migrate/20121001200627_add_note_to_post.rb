class AddNoteToPost < ActiveRecord::Migration
  def change
    add_column :posts, :note, :boolean
  end
end
