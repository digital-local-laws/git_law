FactoryGirl.define do
  factory :gitlab_client_identity do
    user
    host "gitlab.com"
    sequence(:gitlab_user_id) { |n| n }
    sequence(:access_token) { |n| "token#{n}" }
  end
end
