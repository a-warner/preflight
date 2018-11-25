class AddUpdaterToChecklists < ActiveRecord::Migration
  def up
    add_column :checklists, :last_updated_by_id, :integer
    execute %(UPDATE checklists SET last_updated_by_id = created_by_id)
    change_column :checklists, :last_updated_by_id, :integer, null: false
  end

  def down
    remove_column :checklists, :last_updated_by_id
  end
end
