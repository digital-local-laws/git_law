class CreateJurisdictions < ActiveRecord::Migration
  def change
    create_table :jurisdictions do |t|
      t.string :name, null: false
      t.boolean :executive_review, null: false, default: false
      t.string :legislative_body, null: false
      t.string :file_name, null: false
      t.boolean :repo_created, null: false, default: false
      t.boolean :working_repo_created, null: false, default: false

      t.timestamps null: false
    end
    add_index :jurisdictions, :name, unique: true
    add_index :jurisdictions, :file_name, unique: true
  end
end
