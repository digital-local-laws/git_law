FactoryGirl.define do
  factory :gitlab_client_identity_request do
    host "gitlab.example.com"
    sequence(:client_id) { |n| "gl_requestor_#{n}" }
    client_secret { 'noneofyourbusiness' }
  end
end
