class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  attr_accessor :exception

  helper_method :camel?, :current_user, :exception

  before_filter :decamelize_params!, :camelize_output!

  expose :page do
    params[:page] ? params[:page].to_i : 1
  end

  protected

  # Alert client that record was not found
  def not_found
    render nothing: true, status: 404
  end

  # Alert client that action is not authorized for given credentials
  def unauthorized(exception)
    self.exception = exception
    render '/unauthorized', status: 401
  end

  # Conditionally convert params from camelCase
  def decamelize_params!
    params.decamelize! if camel?
  end

  # Conditionally set JSON output to camelize
  def camelize_output!
    Jbuilder.key_format( camelize: :lower ) if camel?
  end

  # Are we in camelCase mode (for interaction with javascript apps)
  def camel?
    return @camel unless @camel.nil?
    @camel = params['camel'] ? true : false
  end
end
