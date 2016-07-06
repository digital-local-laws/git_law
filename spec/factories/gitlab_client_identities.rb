FactoryGirl.define do
  factory :gitlab_client_identity do
    user
    host "gitlab.example.com"
    sequence(:gitlab_app_id) { |n| "gitlab#{n}" }
    sequence(:gitlab_user_id) { |n| n }
    sequence(:gitlab_user_name) { "jdoe" }
    sequence(:access_token) { |n| "token#{n}" }
  end
end
