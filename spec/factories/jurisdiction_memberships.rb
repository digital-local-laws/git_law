FactoryGirl.define do
  factory :jurisdiction_membership do
    association :jurisdiction
    association :user
    adopt false
  end
end
