class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :name, null: false
      t.string :file_name, null: false

      t.timestamps null: false
    end
    add_index :codes, :name, unique: true
    add_index :codes, :file_name, unique: true
  end
end
