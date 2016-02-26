RSpec.shared_examples 'adopt policy' do
  permissions :adopt? do
    it 'should permit an adopter' do
      expect( described_class ).to permit( adopter, record )
    end

    it 'should not permit a non-adopter administrator' do
      expect( described_class ).not_to permit( admin, record )
    end

    it 'should not permit a non-adopter member' do
      expect( described_class ).not_to permit( nonadopter, record )
    end
  end
end
