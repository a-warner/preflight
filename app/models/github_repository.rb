class GithubRepository < ActiveRecord::Base
  has_many :checklists, dependent: :destroy

  validates :github_id, :github_full_name, :github_owner_type, :github_url, presence: true
  validates :github_owner_type, inclusion: %w(Organization User)

  def self.find_or_create_all(repositories)
    repositories.each do |r|
      where(github_id: r.id).first_or_create do |new_repo|
        new_repo.github_full_name = r.full_name
        new_repo.github_owner_type = r.owner.type
        new_repo.github_url = r.html_url
      end
    end
  end

  def self.select_options
    pluck(:github_full_name, :id)
  end

  def apply_checklists_for_pull!(pull_request_webhook)
    transaction do
      pull_id = pull_request_webhook['pull_request']['id']

      to_apply = checklists.includes(:checklist_items).each_with_object([]) do |c, o|
        c.applied_checklists.where(github_pull_request_id: pull_id).first_or_create! do |_|
          o << c
        end
      end

      return unless to_apply.present?

      client   = to_apply.first.github_client
      number   = pull_request_webhook['number']
      body     = client.pull_request(github_full_name, number)['body']
      new_body = (to_apply.map(&:to_markdown) << body).join("\n\n--------\n")

      client.update_pull_request(
        github_full_name,
        number,
        body: new_body
      )
    end
  end
end
