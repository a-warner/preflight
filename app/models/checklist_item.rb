class ChecklistItem < ActiveRecord::Base
  belongs_to :checklist
  validates :name, :created_by, presence: true
  belongs_to :created_by, class_name: 'User'
end
