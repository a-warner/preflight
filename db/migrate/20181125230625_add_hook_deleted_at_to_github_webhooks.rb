class AddHookDeletedAtToGithubWebhooks < ActiveRecord::Migration
  def change
    add_column :github_webhooks, :hook_deleted_at, :datetime
  end
end
