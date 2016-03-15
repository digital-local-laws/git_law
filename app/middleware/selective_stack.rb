class SelectiveStack
  def initialize(app)
    @app = app
  end

  # Conditionally enables sessions only when not in API, which uses
  # token-based authentication
  def call(env)
    if env["PATH_INFO"].start_with?("/api/")
      @app.call(env)
    else
      middleware_stack.build(@app).call(env)
    end
  end

private
  def middleware_stack
    @middleware_stack ||= begin
      ActionDispatch::MiddlewareStack.new.tap do |middleware|
        # needed for OmniAuth
        middleware.use ActionDispatch::Cookies
        middleware.use Rails.application.config.session_store, Rails.application.config.session_options
        middleware.use ::OmniAuth::Builder do
          unless Rails.env.production?
            provider :developer, fields: [:first_name,:last_name,:email],
              uid_field: :email
          end
        end
        # middleware.use OmniAuth::Builder, &OmniAuthConfig
        # needed for Doorkeeper /oauth views
        middleware.use ActionDispatch::Flash
      end
    end
  end
end
