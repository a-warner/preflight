class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider, null: false
      t.belongs_to :user, null: false
      t.string :uid, null: false
      t.text :omniauth_data, null: false

      t.timestamps null: false
    end

    add_index :identities, [:user_id, :provider], unique: true
  end
end
