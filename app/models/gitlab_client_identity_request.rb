class GitlabClientIdentityRequest < ActiveRecord::Base
  belongs_to :user, inverse_of: :gitlab_client_identity_requests

  before_validation do |record|
    record.host.downcase! if record.host
  end

  validates :user, :host, :app_id, :app_secret, presence: true
  validates :app_id, uniqueness: { scope: [ :user_id, :host ] }
  validates :host, format: { with: /\A(?:[a-z0-9\-\_]+\.)*[a-z]+\z/ }

  def authorization_uri_query( redirect_uri )
    URI.encode_www_form(
      client_id: app_id,
      response_type: 'code',
      redirect_uri: redirect_uri
    )
  end

  def authorization_uri( redirect_uri )
    URI::HTTPS.build(
      host: host,
      path: '/oauth/authorize',
      query: authorization_uri_query( redirect_uri )
    )
  end

  def build_gitlab_client_identity( params )
    user.gitlab_client_identities.build( { request: self }.merge( params ) )
  end
end
