require 'rails_helper'

RSpec.describe JurisdictionMembership, type: :model do
  let( :membership ) { build( :jurisdiction_membership ) }

  it 'should save with valid attributes' do
    membership.save!
  end

  context 'validations' do
    it 'should not save without a jurisdiction' do
      membership.jurisdiction = nil
      expect( membership.save ).to be false
    end

    it 'should not save without a user' do
      membership.user = nil
      expect( membership.save ).to be false
    end
  end
end
