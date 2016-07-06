class GitlabClientIdentity < ActiveRecord::Base
  belongs_to :user, inverse_of: :gitlab_client_identities

  before_validation :initialize_gitlab_user_id,
    :initialize_gitlab_user_name, on: :create

  validates :user, :host, :gitlab_user_id, :gitlab_user_name, :access_token,
    presence: true
  validates :gitlab_user_id, uniqueness: { scope: [ :host, :user_id ] }
  validates :access_token, uniqueness: { scope: [ :host, :user_id ] }

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

  def build_publication_job( attributes )
    BuildPublicationJob.perform_later(
      user,
      attributes.merge( { "type" => "gitlab", "host" => host } )
    )
  end
end
