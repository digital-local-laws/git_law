class AddReferendumType < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE referendum_type AS ENUM (
        'mandatory',
        'permissive',
        'city charter revision',
        'county charter adoption'
      );
    SQL
  end
  def down
    execute <<-SQL
      DROP TYPE referendum_type;
    SQL
  end
end
