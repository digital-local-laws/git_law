require 'rails_helper'

describe JurisdictionPolicy do

  let(:admin) { create :user, admin: true }
  let(:staff) { create :user, staff: true }
  let(:nonadopter) {
    create(
      :jurisdiction_membership, adopt: false, jurisdiction: jurisdiction
    ).user
  }
  let(:adopter) {
    create(
      :jurisdiction_membership, adopt: true, jurisdiction: jurisdiction
    ).user
  }
  let(:user) { create :user }
  let(:jurisdiction) { create :jurisdiction }

  subject { described_class }

  permissions :adopt? do
    it 'should permit an adopter' do
      expect( described_class ).to permit( adopter, jurisdiction )
    end

    it 'should not permit a non-adopter administrator' do
      expect( described_class ).not_to permit( admin, jurisdiction )
    end

    it 'should not permit a non-adopter member' do
      expect( described_class ).not_to permit( nonadopter, jurisdiction )
    end
  end

  permissions :index?, :show? do
    it 'should permit any user' do
      expect( described_class ).to permit( user, jurisdiction )
      expect( described_class ).to permit( user, Jurisdiction )
    end
  end

  permissions :update?, :create? do
    it 'should permit an administrator' do
      expect( described_class ).to permit( admin, jurisdiction )
    end

    it 'should permit staff' do
      expect( described_class ).to permit( staff, jurisdiction )
    end

    it 'should not permit an adopter' do
      expect( described_class ).not_to permit( adopter, jurisdiction )
    end

    it 'should not permit an unprivileged user' do
      expect( described_class ).not_to permit( user, jurisdiction )
    end
  end

  permissions :destroy? do
    it 'should permit an administrator' do
      expect( described_class ).to permit( admin, jurisdiction )
    end

    it 'should not permit staff' do
      expect( described_class ).not_to permit( staff, jurisdiction )
    end

    it 'should not permit an adopter' do
      expect( described_class ).not_to permit( adopter, jurisdiction )
    end

    it 'should not permit an unprivileged user' do
      expect( described_class ).not_to permit( user, jurisdiction )
    end
  end
end
