class ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  attr_accessor :exception

  # Alert client that record was not found
  def not_found
    render nothing: true, status: 404
  end

  # Alert client that action is not authorized for given credentials
  def unauthorized(exception)
    self.exception = exception
    format.json { render template: 'api/unauthorized', status: 401 }
  end
end
