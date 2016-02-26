require 'rails_helper'

describe ProposedLawPolicy, type: :policy do
  include_context 'authorization'

  let(:record) { proposed_law }

  subject { described_class }

  include_examples 'adopt policy'
  include_examples 'propose policy'

  permissions :index?, :show? do
    it 'should permit any user' do
      expect( described_class ).to permit( user, record )
      expect( described_class ).to permit( user, record.class )
    end
  end

  permissions :update?, :destroy? do
    it 'should not permit an administrator' do
      expect( described_class ).not_to permit( admin, record )
    end

    it 'should not permit staff' do
      expect( described_class ).not_to permit( staff, record )
    end

    it 'should not permit an adopter' do
      expect( described_class ).not_to permit( adopter, record )
    end

    it 'should not permit a proposer' do
      expect( described_class ).not_to permit( proposer, record )
    end

    it 'should permit an owner' do
      expect( described_class ).to permit( owner, record )
    end

    it 'should not permit an owner without propose rights' do
      membership = owner.jurisdiction_memberships.first
      membership.propose = false
      membership.save!
      owner.reload
      expect( described_class ).not_to permit( owner, record )
    end

    it 'should not permit an unprivileged user' do
      expect( described_class ).not_to permit( user, record )
    end
  end

  permissions :create? do
    let(:record) { jurisdiction.proposed_laws.build }

    it 'should not permit an administrator' do
      expect( described_class ).not_to permit( admin, record )
    end

    it 'should not permit staff' do
      expect( described_class ).not_to permit( staff, record )
    end

    it 'should not permit an adopter' do
      expect( described_class ).not_to permit( adopter, record )
    end

    it 'should permit a proposer' do
      expect( described_class ).to permit( proposer, record )
    end

    it 'should not permit an unprivileged user' do
      expect( described_class ).not_to permit( user, record )
    end
  end
end
