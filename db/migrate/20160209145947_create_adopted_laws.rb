class CreateAdoptedLaws < ActiveRecord::Migration
  def change
    create_table :adopted_laws do |t|
      t.references :proposed_law, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
