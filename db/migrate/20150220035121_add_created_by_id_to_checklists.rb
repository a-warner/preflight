class AddCreatedByIdToChecklists < ActiveRecord::Migration
  def change
    add_column :checklists, :created_by_id, :integer, null: false
    add_column :checklist_items, :created_by_id, :integer, null: false
  end
end
