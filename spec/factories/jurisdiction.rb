FactoryGirl.define do
  factory :jurisdiction do
    sequence(:name) { |i| "Jurisdiction #{i}" }
    legislative_body { |j| "#{j.name} Legislature" }
  end
end
