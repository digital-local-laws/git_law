class CreateJurisdictions < ActiveRecord::Migration
  def change
    create_table :jurisdictions do |t|
      t.column :government_type, :government_type, null: false, index: true
      t.string :name, null: false
      t.boolean :executive_review, null: false, default: false
      t.string :legislative_body, null: false
      t.string :file_name, null: false
      t.boolean :repo_created, null: false, default: false
      t.boolean :working_repo_created, null: false, default: false

      t.timestamps null: false
    end
    add_index :jurisdictions, [ :government_type, :name ],
      unique: true, name: 'jurisdictions_name'
    add_index :jurisdictions, :file_name, unique: true
  end
end
