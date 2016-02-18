class CreateJurisdictionMemberships < ActiveRecord::Migration
  def change
    create_table :jurisdiction_memberships do |t|
      t.references :jurisdiction, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :adopt

      t.timestamps null: false
    end
  end
end
