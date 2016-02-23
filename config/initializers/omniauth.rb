# Rails.application.config.middleware.use OmniAuth::Builder do
#   unless Rails.env.production?
#     provider :developer
#   end
# end

OmniAuth.config.logger = Rails.logger
