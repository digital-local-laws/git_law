FactoryGirl.define do
  factory :code do
    sequence(:name) { |i| "Code #{i}" }
  end
end
