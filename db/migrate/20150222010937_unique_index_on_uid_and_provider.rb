class UniqueIndexOnUidAndProvider < ActiveRecord::Migration
  def change
    add_index :identities, [:uid, :provider], unique: true
  end
end
