require 'rails_helper'

describe GitlabClientIdentityRequestPolicy do

  subject { described_class }

  include_context 'authorization'

  let(:identity_request) { create :gitlab_client_identity_request }

  permissions :be? do
    it 'should permit the owner' do
      expect(described_class).to permit( identity_request.user, identity_request )
    end

    it "should not permit admin" do
      expect(described_class).not_to permit( admin, identity_request )
    end

    it 'should not permit another user' do
      expect(described_class).not_to permit( create(:user), identity_request )
    end
  end

  permissions :create?, :show? do
    it 'should permit the owner' do
      expect(described_class).to permit( identity_request.user, identity_request )
    end

    it "should permit staff" do
      expect(described_class).to permit( staff, identity_request  )
    end

    it "should permit admin" do
      expect(described_class).to permit( admin, identity_request )
    end

    it 'should not permit another user' do
      expect(described_class).not_to permit( create(:user), identity_request )
    end
  end
end
