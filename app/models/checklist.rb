class Checklist < ActiveRecord::Base
  validates :name, :created_by, :github_repository, presence: true
  has_many :checklist_items, dependent: :destroy
  belongs_to :created_by, class_name: 'User'
  belongs_to :github_repository
  after_create :hook_repository

  validate :user_can_access_repository

  def self.for_repositories(github_repositories)
    where("github_repository_id IN (#{github_repositories.select(:id).to_sql})")
  end

  protected

  def hook_repository
    GithubWebhook.hook!(created_by, github_repository)
  end

  private

  def user_can_access_repository
    return unless github_repository.present? && created_by.present?
    created_by.can_access_repository?(github_repository)
  end
end
