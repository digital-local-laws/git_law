FactoryGirl.define do
  factory :proposed_law do
    association :jurisdiction
    association :user
    sequence(:title) { |i| "Proposed law #{i}" }
    factory :executive_proposed_law do
      association :jurisdiction, factory: :executive_jurisdiction
    end
  end
end
