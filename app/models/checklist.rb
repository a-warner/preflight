class Checklist < ActiveRecord::Base
  validates :name, presence: true
  has_many :checklist_items, dependent: :destroy
end
