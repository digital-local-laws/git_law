FactoryGirl.define do
  factory :adopted_law do
    association :proposed_law
    adopted_on { Time.zone.today }
    referendum_required { false }

    factory :executive_adopted_law do
      association :proposed_law, factory: :executive_proposed_law
      executive_action { 'approved' }
      executive_action_date { Time.zone.today }
    end

    factory :mandatory_referendum_adopted_law do
      referendum_required { true }
      referendum_type { 'mandatory' }
      election_type { 'general' }
    end

    factory :permissive_referendum_adopted_law do
      referendum_required { true }
      referendum_type { 'permissive' }
      permissive_petition { false }
    end
  end
end
