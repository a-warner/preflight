json.array!(@checklists) do |checklist|
  json.extract! checklist, :id
  json.url checklist_url(checklist, format: :json)
end
