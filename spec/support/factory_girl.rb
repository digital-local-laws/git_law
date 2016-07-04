RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    begin
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
      factories_to_lint = FactoryGirl.factories.reject do |factory|
        factory.name =~ /^gitlab_client_identity_request/
      end
      FactoryGirl.lint factories_to_lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
