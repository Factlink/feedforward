class RemoveGroupNameIndexFromGroups < ActiveRecord::Migration
  def up
    remove_index :groups,  column: :groupname
  end

  def down
    add_index :groups, :groupname, {unique: true}
  end
end
