class CreateJurisdictionMemberships < ActiveRecord::Migration
  def change
    create_table :jurisdiction_memberships do |t|
      t.references :jurisdiction, null: false, index: true, foreign_key: true,
        on_delete: :cascade
      t.references :user, null: false, index: true, foreign_key: true,
        on_delete: :cascade
      t.boolean :adopt
      t.boolean :propose

      t.timestamps null: false
    end
    add_index :jurisdiction_memberships, [ :jurisdiction_id, :user_id ],
      unique: true
  end
end
