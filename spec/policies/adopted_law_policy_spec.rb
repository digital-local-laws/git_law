require 'rails_helper'

describe AdoptedLawPolicy, type: :policy do
  include_context 'authorization'

  let(:record) { adopted_law }

  subject { described_class }

  permissions :index?, :show? do
    it 'should permit any user' do
      expect( described_class ).to permit( user, record )
      expect( described_class ).to permit( user, record.class )
    end
  end

  permissions :create? do
    let(:record) { proposed_law.build_adopted_law }

    it 'should not permit an administrator' do
      expect( described_class ).not_to permit( admin, record )
    end

    it 'should not permit staff' do
      expect( described_class ).not_to permit( staff, record )
    end

    it 'should permit an adopter' do
      expect( described_class ).to permit( adopter, record )
    end

    it 'should not permit a proposer' do
      expect( described_class ).not_to permit( proposer, record )
    end

    it 'should not permit an unprivileged user' do
      expect( described_class ).not_to permit( user, record )
    end
  end
end
