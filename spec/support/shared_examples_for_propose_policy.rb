RSpec.shared_examples 'propose policy' do
  permissions :propose? do
    it 'should permit a proposer' do
      expect( described_class ).to permit( proposer, record )
    end

    it 'should not permit a non-adopter administrator' do
      expect( described_class ).not_to permit( admin, record )
    end

    it 'should not permit a non-proposer member' do
      expect( described_class ).not_to permit( nonadopter, record )
    end
  end
end
