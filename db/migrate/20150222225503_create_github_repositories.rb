class CreateGithubRepositories < ActiveRecord::Migration
  def change
    create_table :github_repositories do |t|
      t.integer :github_id, null: false
      t.string :github_full_name, null: false
      t.string :github_owner_type, null: false
      t.string :github_url, null: false

      t.timestamps null: false
    end

    add_index :github_repositories, :github_id, unique: true

    add_column :users, :accessible_github_repository_ids, :text, array: true, default: []

    add_column :checklists, :github_repository_id, :integer, null: false
    add_index :checklists, :github_repository_id
  end
end
