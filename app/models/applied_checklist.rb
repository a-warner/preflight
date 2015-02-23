class AppliedChecklist < ActiveRecord::Base
  belongs_to :checklist

  validates :checklist, :github_pull_request_id, presence: true
  validates :checklist_id, uniqueness: {scope: :github_pull_request_id}
end
