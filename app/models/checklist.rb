class Checklist < ActiveRecord::Base
  validates :name, :created_by, :github_repository, presence: true
  has_many :checklist_items, dependent: :destroy
  has_many :applied_checklists, dependent: :destroy
  belongs_to :created_by, class_name: 'User'
  belongs_to :last_updated_by, class_name: 'User'
  belongs_to :github_repository

  validate :user_can_access_repository
  validate :matching_pattern_is_valid_regexp

  after_save :clear_updater

  attr_reader :updater

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

  def updater=(user)
    @updater = user

    self.last_updated_by = user
    self.created_by = user if new_record?
  end

  private

  def user_can_access_repository
    return unless github_repository.present? && updater.present?

    unless updater.can_access_repository?(github_repository)
      errors.add(:base, "You do not have access to this repository")
    end
  end

  def matching_pattern_is_valid_regexp
    return unless with_file_matching_pattern.present?
    Regexp.new(with_file_matching_pattern)
  rescue RegexpError
    errors.add(:with_file_matching_pattern, 'is not a valid regular expression')
  end

  def clear_updater
    @updater = nil
  end
end
