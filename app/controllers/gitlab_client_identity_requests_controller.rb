class GitlabClientIdentityRequestsController < ApplicationController
  before_action :authenticate_user!

  expose :user do
    User.find params[:user_id]
  end

  expose :identity_request do
    if params[:id]
      GitlabClientIdentityRequest.find params[:id]
    else
      user.gitlab_client_identity_requests.build(
        gitlab_client_identity_request_params
      )
    end
  end

  helper_method :gitlab_request_uri

  def create
    authorize identity_request, :create?
    if identity_request.valid?
      render 'show', status: 201
    else
      render json: identity_request.errors, status: 422
    end
  end

  def show
    authorize identity_request, :show?
    render 'show', status: 200
  end

  private

  def gitlab_request_uri
    @gitlab_request_uri ||= "#{request.headers['Referer']}?gitlab_client_identity_request_id=#{identity_request.id}"
  end

  def gitlab_client_identity_request_params
    @gitlab_client_identity_request_params ||= params.
      permit( :host, :app_id, :app_secret )
  end
end
