FactoryGirl.define do
  factory :user do
    first_name { "John" }
    last_name { "Doe" }
    sequence(:email) { |i| "user#{i}@example.com" }
    uid { |user| user.email }
    provider { 'developer' }
    password { 'secretsquirrel' }
    password_confirmation { password }
    after(:build) { |user| user.skip_confirmation! }
  end
end
