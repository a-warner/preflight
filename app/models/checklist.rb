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
    "#### #{name}\n" + checklist_items.map(&:to_markdown).join("\n")
  end

  delegate :github_client, to: :created_by

  def apply_to_pull_with_files?(files)
    return true unless with_file_matching_pattern.present?
    re = Regexp.new(with_file_matching_pattern)

    files.any? { |f| f.filename =~ re }
  end

  def as_json(options = {})
    {
      id: id,
      name: name,
      repository_path: UrlHelpers.github_repository_path(github_repository),
      edit_path: UrlHelpers.edit_checklist_path(self),
      items: checklist_items.sort_by { |i| i.id || Float::INFINITY }.map(&:as_json),
      github_repository_full_name: github_repository.github_full_name,
      index_path: UrlHelpers.checklists_path
    }
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
