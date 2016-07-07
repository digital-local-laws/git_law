FactoryGirl.define do
  factory :gitlab_client_identity do
    association :request, factory: :gitlab_client_identity_request
    code { 'noneofyourbusiness' }
    sequence(:gitlab_user_id) { |n| n }
    sequence(:gitlab_user_name) { "jdoe" }
    sequence(:access_token) { |n| "token#{n}" }
  end
end
