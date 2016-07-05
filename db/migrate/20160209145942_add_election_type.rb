class AddElectionType < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE election_type AS ENUM (
        'general',
        'special',
        'annual'
      );
    SQL
  end
  def down
    execute <<-SQL
      DROP TYPE election_type;
    SQL
  end
end
