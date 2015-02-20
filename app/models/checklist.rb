class Checklist < ActiveRecord::Base
  validates :name, :created_by, presence: true
  has_many :checklist_items, dependent: :destroy
  belongs_to :created_by, class_name: 'User'
end
