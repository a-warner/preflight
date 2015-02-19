class ChecklistItem < ActiveRecord::Base
  belongs_to :checklist
  validates :name, presence: true
end
