class Checklist < ActiveRecord::Base
  validates :name, presence: true
end
