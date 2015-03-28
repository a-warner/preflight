class ChecklistItem < ActiveRecord::Base
  belongs_to :checklist
  validates :name, :created_by, presence: true
  belongs_to :created_by, class_name: 'User'

  def to_markdown
    "- [ ] #{name}"
  end

  def as_json(options = {})
    {
      id: id,
      name: name,
      path: UrlHelpers.polymorphic_path([checklist, self])
    }
  end
end
