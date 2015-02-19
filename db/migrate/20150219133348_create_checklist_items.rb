class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.string :name, null: false
      t.belongs_to :checklist, null: false

      t.timestamps null: false
    end
  end
end
