class ApplicationController < ActionController::Base
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  after_filter :set_csrf_cookie_for_ng
  
  helper_method :camel?, :current_user
  
  def index
  end
  
  protected
  
  def current_user=(user)
    session[:current_user_id] = user.id
  end
  
  def current_user
    @current_user ||= session[:current_user_id] && User.find( session[:current_user_id] )
  end
  
  # Pass XSS token for angular application
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
  
  # Look for angular application XSS verification token
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
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
