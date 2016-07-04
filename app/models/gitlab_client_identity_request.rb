class GitlabClientIdentityRequest
  include ActiveModel::Model

  attr_accessor :host, :client_id, :client_secret

  validates :host, :client_id, :client_secret, presence: true
end
