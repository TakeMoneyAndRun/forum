class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.references :topic
      t.references :user

      t.timestamps
    end
    add_index :posts, :topic_id
    add_index :posts, :user_id
  end
end
