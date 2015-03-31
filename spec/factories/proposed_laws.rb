FactoryGirl.define do
  factory :proposed_law do
    association :jurisdiction
    association :user
    sequence(:title) { |i| "Proposed law #{i}" }
  end
end
