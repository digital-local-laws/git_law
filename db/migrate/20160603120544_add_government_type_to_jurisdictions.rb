class AddGovernmentTypeToJurisdictions < ActiveRecord::Migration
  class Jurisdiction < ActiveRecord::Base
  end
  def up
    execute <<-SQL
      CREATE TYPE government_type AS ENUM ('city','county','town','village');
    SQL
    add_column :jurisdictions, :government_type, :government_type
    Jurisdiction.where( government_type: nil ).update_all government_type: 'city'
    change_column :jurisdictions, :government_type, :government_type, null: false
    add_index :jurisdictions, :government_type
    add_index :jurisdictions, [ :government_type, :name ]
  end

  def down
    remove_index :jurisdictions, [ :government_type, :name ]
    remove_index :jurisdictions, :government_type
    remove_column :jurisdictions, :government_type
    execute <<-SQL
      DROP TYPE government_type;
    SQL
  end
end
