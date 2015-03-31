FactoryGirl.define do
  factory :jurisdiction do
    sequence(:name) { |i| "Jurisdiction #{i}" }
  end
end
