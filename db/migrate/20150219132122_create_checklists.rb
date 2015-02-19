class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name, :null => false

      t.timestamps null: false
    end
  end
end
