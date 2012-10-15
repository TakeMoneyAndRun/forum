class ChangeDataTypeForExpiresAt < ActiveRecord::Migration
  def up
    change_table :bans do |t|
      t.change :expires_at, :date
    end
  end

  def down
    change_table :bans do |t|
      t.change :expires_at, :time
    end
  end
end
