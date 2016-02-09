FactoryGirl.define do
  factory :adopted_law do
    association :proposed_law
  end
end
