class CreateComplains < ActiveRecord::Migration
  def change
    create_table :complains do |t|
      t.references :user
      t.references :post
      t.string :reason

      t.timestamps
    end
    add_index :complains, :user_id
    add_index :complains, :post_id
  end
end
