class CreateProposedLaws < ActiveRecord::Migration
  def change
    create_table :proposed_laws do |t|
      t.references :code, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
