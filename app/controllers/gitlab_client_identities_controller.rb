class GitlabClientIdentitiesController < ApplicationController
  before_action :authenticate_user!

  expose :user do
    User.find params[:user_id]
  end

  expose :host do
    if params['host'] && params['host'].downcase =~ /^(?:[a-z0-9\-\_]+\.)*[a-z]+$/
      user_session['gitlab_host'] = params['host'].downcase
    end
    if user_session['gitlab_host']
      CGI.escape( user_session['gitlab_host'] )
    end
  end

  expose :client_id do
    if params['client_id']
      user_session['gitlab_client_id'] = params['client_id']
    end
    if user_session['gitlab_client_id']
      CGI.escape( user_session['gitlab_client_id'] )
    end
  end

  expose :client_secret do
    if params['client_secret']
      user_session['gitlab_client_secret'] = params['client_secret']
    end
    if user_session['gitlab_client_secret']
      CGI.escape( user_session['gitlab_client_secret'] )
    end
  end

  expose :gitlab_client_identity do
    GitlabClientIdentity.find params[:id]
  end

  expose( :unpaginated_gitlab_client_identities ) do
    s = user.gitlab_client_identities
    s = s.order :host, :gitlab_user_id
  end

  expose :identity_request do
    GitlabClientIdentityRequest.new(
      host: host,
      client_id: client_id,
      client_secret: client_secret
    )
  end

  expose :new_gitlab_client_identity do
    user.gitlab_client_identities.build
  end

  helper_method :gitlab_client_identities

  def new
    authorize new_gitlab_client_identity, :new?
    reset_gitlab_session_variables
    if identity_request.valid?
      render json: {
        "authorization_url" => "https://#{host}/oauth/authorize?" +
          "client_id=#{client_id}&" +
          "redirect_uri=#{CGI.escape '/?gitlab=true'}&" +
          "response_type=code"
        },
        status: 200
    else
      render json: identity_request.errors, status: 422
    end
  end

  def create
    authorize new_gitlab_client_identity, :create?
    parameters = {
      client_id: client_id,
      client_secret: client_secret,
      code: params['code'],
      grant_type: 'authorization_code',
      redirect_uri: '/?gitlab=true'
    }
    response = RestClient.post( "https://#{host}/oauth/token", parameters )
    if response.code == 200
      user.gitlab_client_identities.create!(
        host: host,
        gitlab_user_id: client_id,
        access_token: JSON.parse(response.body)['access_token']
      )
      reset_gitlab_session_variables
      render 'show', status: 201
    else
      render plain: "#{response}", status: 500
    end
  end

  def index
    authorize new_gitlab_client_identity, :index?
    if page == 1 || gitlab_client_identities.any?
      render status: 200
    else
      render nothing: true, status: 404
    end
  end

  def destroy
    authorize gitlab_client_identity, :destroy?
    if gitlab_client_identity.destroy
      render nothing: true, status: 204
    else
      render nothing: true, status: 500
    end
  end

  private

  def authorize_user!
    if params[:id]
      authorize gitlab_client_identity
    else
      authorize GitlabClientIdentity.new user: user
    end
  end

  def gitlab_client_identities
    @gitlab_client_identities ||= paginate unpaginated_gitlab_client_identities
  end

  def reset_gitlab_session_variables
    user_session['gitlab_host'] = nil
    user_session['gitlab_client_id'] = nil
    user_session['gitlab_client_secret'] = nil
  end
end
