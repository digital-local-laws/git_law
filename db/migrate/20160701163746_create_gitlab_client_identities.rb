class CreateGitlabClientIdentities < ActiveRecord::Migration
  def change
    create_table :gitlab_client_identities do |t|
      t.references :user, null: false
      t.string :host, null: false
      t.integer :gitlab_user_id, null: false
      t.string :access_token, null: false

      t.timestamps, null: false
    end
    add_index :gitlab_client_identities, [ :user_id, :host, :gitlab_user_id ],
      name: 'unique_identity', unique: true
    add_index :gitlab_client_identities, [ :user_id, :host, :access_token ],
      name: 'unique_token', unique: true
  end
end
