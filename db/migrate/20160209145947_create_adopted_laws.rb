class CreateAdoptedLaws < ActiveRecord::Migration
  def change
    create_table :adopted_laws do |t|
      t.date :adopted_on, null: false
      t.references :jurisdiction, null: false, index: true, foreign_key: true,
        on_delete: :restrict
      t.integer :year_adopted, null: false
      t.integer :number_in_year, null: false
      t.string :local_number
      t.references :proposed_law, null: false, index: true, foreign_key: true,
        on_delete: :restrict
      t.column :executive_action, :executive_action_type
      t.date :executive_action_on
      t.boolean :referendum_required
      t.column :referendum_type, :referendum_type
      t.boolean :permissive_petition
      t.column :election_type, :election_type

      t.timestamps null: false
    end
    add_index :adopted_laws,
      [ :jurisdiction_id, :year_adopted, :number_in_year ],
      unique: true, name: 'number_in_year'
  end
end
