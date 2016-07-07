class GitlabClientIdentity < ActiveRecord::Base
  belongs_to :user, inverse_of: :gitlab_client_identities

  attr_accessor :code, :request

  before_validation :initialize_access_token, :initialize_gitlab_user_id,
    :initialize_gitlab_user_name, on: :create
  after_create :destroy_request

  validates :code, :request, presence: true, on: :create
  validates :user, :host, :gitlab_user_id, :gitlab_user_name, :access_token,
    presence: true
  validates :gitlab_user_id, uniqueness: { scope: [ :host, :user_id ] }
  validates :access_token, uniqueness: { scope: [ :host, :user_id ] }

  def request=(new_request)
    @request = new_request
    self.user = request.user
    self.host = request.host
    self.gitlab_app_id = request.app_id
  end

  # Initialize the access token
  def initialize_access_token( force = false )
    return if access_token && !force
    self.access_token = obtain_access_token
  end

  def obtain_access_token
    return nil unless code && request
    parameters = {
      client_id: gitlab_app_id,
      client_secret: request.app_secret,
      code: code,
      grant_type: 'authorization_code'
    }
    begin
      response = RestClient.post( "https://#{request.host}/oauth/token", parameters )
      if response.code == 200
        return JSON.parse( response.body )['access_token']
      end
    # rescue JSON::ParserError => e
    end
  end

  # Discover the gitlab user identifier corresponding to the authenticated
  # gitlab identity if no identifier is yet set
  def initialize_gitlab_user_id( force = false )
    return if gitlab_user_id && !force
    self.gitlab_user_id = gitlab_user.id
  end

  # Discover the gitlab username corresponding to the authenticated
  # gitlab identity if no identifier is yet set
  def initialize_gitlab_user_name( force = false )
    return if gitlab_user_name && !force
    self.gitlab_user_name = gitlab_user.username
  end

  def gitlab_user
    return unless host && access_token
    @gitlab_user ||= client.user
  end

  # Get instance of gitlab client with connection to user's API
  def client(reset = false)
    @client = nil if reset
    return @client if @client
    return nil unless access_token
    @client = Gitlab.client( endpoint: "https://#{host}/api/v3", auth_token: access_token )
  end

  def destroy_request
    request.destroy
  end
end
