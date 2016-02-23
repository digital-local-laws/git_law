class ApplicationController < ActionController::API
  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  helper_method :camel?, :current_user

  protected

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
