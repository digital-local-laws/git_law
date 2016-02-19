FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@example.com" }
    password { 'secretsquirrel' }
    password_confirmation { password }
  end
end
