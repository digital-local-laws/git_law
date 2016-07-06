require 'rails_helper'

describe GitlabClientIdentityPolicy do

  subject { described_class }

  include_context 'authorization'

  let(:identity) { create :gitlab_client_identity }

  permissions :be? do
    it 'should permit the owner' do
      expect(described_class).to permit( identity.user, identity )
    end

    it "should not permit admin" do
      expect(described_class).not_to permit( admin, identity )
    end

    it 'should not permit another user' do
      expect(described_class).not_to permit( create(:user), identity )
    end
  end

  permissions :create?, :destroy?, :index?, :show? do
    it 'should permit the owner' do
      expect(described_class).to permit( identity.user, identity )
    end

    it "should permit staff" do
      expect(described_class).to permit( staff, identity  )
    end

    it "should permit admin" do
      expect(described_class).to permit( admin, identity )
    end

    it 'should not permit another user' do
      expect(described_class).not_to permit( create(:user), identity )
    end
  end
end
