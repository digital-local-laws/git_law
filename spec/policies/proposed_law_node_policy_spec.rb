require 'rails_helper'

describe ProposedLawNodePolicy, type: :policy do
  include_context 'authorization'

  let(:record) { proposed_law_node }

  subject { described_class }

  permissions :index?, :show? do
    it 'should permit any user' do
      expect( described_class ).to permit( user, record )
      expect( described_class ).to permit( user, record.class )
    end
  end

  permissions :create?, :update?, :destroy? do
    include_examples 'owner only policy'
  end
end
