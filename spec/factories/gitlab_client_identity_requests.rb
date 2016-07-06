FactoryGirl.define do
  factory :gitlab_client_identity_request do
    user
    host "gitlab.example.com"
    sequence(:app_id) { |n| "gl_requestor_#{n}" }
    app_secret { 'noneofyourbusiness' }
  end
end
