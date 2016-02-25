module DeviseTestHelpers
  def self.included( klass )
    klass.send :attr_accessor, :auth_headers
    klass.send :attr_reader, :request
  end

  # For token authentication, we need to generate token and include in
  # request headers
  def token_sign_in( user )
    if auth_headers
      auth_headers.merge user.create_new_auth_token
    else
      self.auth_headers = user.create_new_auth_token
    end
    auth_headers.each do |header, value|
      request.headers[header] = value
    end
  end
end

RSpec.configure do |config|
  config.include DeviseTestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :controller
  # config.include Devise::TestHelpers, type: :view
end
