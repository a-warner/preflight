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
end
