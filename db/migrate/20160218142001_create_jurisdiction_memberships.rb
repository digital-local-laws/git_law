class CreateJurisdictionMemberships < ActiveRecord::Migration
  def change
    create_table :jurisdiction_memberships do |t|
      t.references :jurisdiction, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :adopt
      t.boolean :propose

      t.timestamps null: false
    end
    add_index :jurisdiction_memberships, [ :jurisdiction_id, :user_id ],
      unique: true
  end
end
