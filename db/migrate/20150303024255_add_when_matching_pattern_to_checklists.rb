class AddWhenMatchingPatternToChecklists < ActiveRecord::Migration
  def change
    add_column :checklists, :with_file_matching_pattern, :string
  end
end
