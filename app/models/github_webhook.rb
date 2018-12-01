class GithubWebhook < ActiveRecord::Base
  belongs_to :github_repository
  belongs_to :created_by, class_name: 'User'

  validates :created_by, presence: true
  validates :github_id, :github_repository, presence: true, uniqueness: true

  def self.unhook_all_hooked_by_old_oauth_integration!
    where(hook_deleted_at: nil).find_each do |hook|
      hook.transaction do
        hook.hook_deleted_at = Time.now

        hook.created_by.github_client.remove_hook(hook.github_repository.github_full_name, hook.github_id)

        hook.save!
      end
    end
  end
end
