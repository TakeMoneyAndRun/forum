class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.text :reason
      t.time :expires_at

      t.timestamps
    end
  end
end
