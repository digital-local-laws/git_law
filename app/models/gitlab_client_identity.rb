class GitlabClientIdentity < ActiveRecord::Base
  belongs_to :user, inverse_of: :gitlab_client_identities

  # before_validation :initialize_gitlab_user_id, on: :create

  validates :user, :host, :gitlab_user_id, :access_token, presence: true
  validates :gitlab_user_id, uniqueness: { scope: [ :host, :user_id ] }
  validates :access_token, uniqueness: { scope: [ :host, :user_id ] }

  # Discover the gitlab user identifier corresponding to the authenticated
  # gitlab identity if no identifier is yet set
  def initialize_gitlab_user_id
    return if gitlab_user_id
    return unless host && access_token
    self.gitlab_user_id = client.user.id
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
