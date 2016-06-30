class CreateAdoptedLaws < ActiveRecord::Migration
  def up
    create_table :adopted_laws do |t|
      execute <<-SQL
        CREATE TYPE executive_action AS ENUM (
          'approved',
          'allowed',
          'rejected'
        );
        CREATE TYPE referendum_type AS ENUM (
          'mandatory',
          'permissive',
          'city charter revision',
          'county charter adoption'
        );
        CREATE TYPE election_type AS ENUM (
          'general',
          'special',
          'annual'
        );
      SQL
      t.date :adopted_on, null: false
      t.references :jurisdiction, null: false, index: true, foreign_key: true
      t.integer :year_adopted, null: false
      t.integer :number_in_year, null: false
      t.string :local_number
      t.references :proposed_law, null: false, index: true, foreign_key: true
      t.column :executive_action, :executive_action
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

  def down
    remove_index :adopted_laws, name: 'number_in_year'
    drop_table :adopted_laws
    execute <<-SQL
      DROP TYPE election_type;
      DROP TYPE referendum_type;
      DROP TYPE executive_action;
    SQL
  end
end
