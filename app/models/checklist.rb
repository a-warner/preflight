class Checklist < ActiveRecord::Base
  validates :name, :created_by, :github_repository, presence: true
  has_many :checklist_items, dependent: :destroy
  has_many :applied_checklists, dependent: :destroy
  belongs_to :created_by, class_name: 'User'
  belongs_to :github_repository
  after_create :hook_repository

  validate :user_can_access_repository

  def self.for_repositories(github_repositories)
    where("github_repository_id IN (#{github_repositories.select(:id).to_sql})")
  end

  def to_markdown
    "# #{name}\n" + checklist_items.map(&:to_markdown).join("\n")
  end

  delegate :github_client, to: :created_by

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
