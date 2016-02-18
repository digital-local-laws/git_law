class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :admin, null: false, default: false
      t.boolean :staff, null: false, default: false
      t.string :email, null: false
      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :admin
    add_index :users, :staff
  end
end
