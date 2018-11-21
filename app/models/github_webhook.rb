class GithubWebhook < ActiveRecord::Base
  belongs_to :github_repository
  belongs_to :created_by, class_name: 'User'

  validates :created_by, presence: true
  validates :github_id, :github_repository, presence: true, uniqueness: true

  def self.hook!(created_by, repository)
    where(github_repository_id: repository.id).first_or_create! do |r|
      webhook = created_by.github_client.create_default_hook(repository)

      r.github_id = webhook.id
      r.created_by = created_by
    end
  end

  def self.unhook_all_hooked_by_old_oauth_integration!
    # TODO
  end
end
