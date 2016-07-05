class CreateProposedLaws < ActiveRecord::Migration
  def change
    create_table :proposed_laws do |t|
      t.references :jurisdiction, index: true, foreign_key: true, null: false,
        on_delete: :restrict
      t.references :user, index: true, foreign_key: true, null: false
      t.string :title
      t.boolean :repo_created, null: false, default: false
      t.boolean :working_repo_created, null: false, default: false

      t.timestamps null: false
    end
    add_index :proposed_laws, :title
  end
end
