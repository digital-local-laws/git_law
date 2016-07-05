class AddGovernmentType < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE government_type AS ENUM ('city','county','town','village');
    SQL
  end

  def down
    execute <<-SQL
      DROP TYPE government_type;
    SQL
  end
end
