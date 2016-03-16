require 'rails_helper'

describe UserPolicy do

  subject { described_class }

  include_context 'authorization'

  permissions :be? do
    it 'should permit the owner' do
      expect(described_class).to permit( user, user )
    end

    it 'should not permit another user' do
      expect(described_class).not_to permit( create(:user), user )
    end
  end

  permissions :show?, :create?, :update?, :index? do
    it 'should permit an administrator' do
      expect( described_class ).to permit( admin, User )
      expect( described_class ).to permit( admin, user )
    end

    it 'should permit staff' do
      expect( described_class ).to permit( staff, User )
      expect( described_class ).to permit( staff, user )
    end

    it 'should not permit a non-administrator' do
      expect( described_class ).not_to permit( user, User )
      expect( described_class ).not_to permit( user, user )
    end
  end

  permissions :destroy? do
    it 'should permit an administrator' do
      expect( described_class ).to permit( admin, User )
      expect( described_class ).to permit( admin, user )
    end

    it 'should not permit staff' do
      expect( described_class ).not_to permit( staff, User )
      expect( described_class ).not_to permit( staff, user )
    end

    it 'should not permit a non-administrator' do
      expect( described_class ).not_to permit( user, User )
      expect( described_class ).not_to permit( user, user )
    end
  end
end
