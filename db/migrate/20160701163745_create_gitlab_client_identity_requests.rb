class CreateGitlabClientIdentityRequests < ActiveRecord::Migration
  def change
    create_table :gitlab_client_identity_requests do |t|
      t.references :user, null: false, index: true, foreign_key: true,
        on_delete: :cascade
      t.string :host, null: false
      t.string :app_id, null: false
      t.string :app_secret, null: false

      t.timestamps null: false
    end
    add_index :gitlab_client_identity_requests, [ :user_id, :host, :app_id ],
      name: 'gitlab_client_identity_request_app_id', unique: true
  end
end
