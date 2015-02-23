class CreateAppliedChecklists < ActiveRecord::Migration
  def change
    create_table :applied_checklists do |t|
      t.belongs_to :checklist, null: false
      t.integer :github_pull_request_id, null: false

      t.timestamps null: false
    end

    add_index :applied_checklists, [:github_pull_request_id, :checklist_id], unique: true, name: 'one_checklist_application_per_pull'
    add_index :applied_checklists, :checklist_id
  end
end
