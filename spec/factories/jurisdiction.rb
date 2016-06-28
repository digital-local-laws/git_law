FactoryGirl.define do
  factory :jurisdiction do
    sequence(:name) { |i| "Jurisdiction #{i}" }
    legislative_body { |j| "#{j.name} Legislature" }
    government_type { 'town' }
    factory :executive_jurisdiction do
      executive_review { true }
    end
  end
end
