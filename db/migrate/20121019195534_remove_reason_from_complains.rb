class RemoveReasonFromComplains < ActiveRecord::Migration
  def up
  end

  def down
    remove_column :complains, :reason
  end
end
