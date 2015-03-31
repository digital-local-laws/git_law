class CreateJurisdictions < ActiveRecord::Migration
  def change
    create_table :jurisdictions do |t|
      t.string :name, null: false
      t.string :file_name, null: false

      t.timestamps null: false
    end
    add_index :jurisdictions, :name, unique: true
    add_index :jurisdictions, :file_name, unique: true
  end
end
