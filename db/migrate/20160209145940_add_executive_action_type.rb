class AddExecutiveActionType < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE executive_action_type AS ENUM (
        'approved',
        'allowed',
        'rejected'
      );
    SQL
  end
  def down
    execute <<-SQL
      DROP TYPE executive_action_type;
    SQL
  end
end
