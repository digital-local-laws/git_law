RSpec.shared_context 'authorization' do
  let(:user) { create :user }
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
  let(:proposer) {
    user = create(
      :jurisdiction_membership, propose: true, jurisdiction: jurisdiction
    ).user
  }
  let(:owner) {
    user = create(
      :jurisdiction_membership, propose: true, jurisdiction: jurisdiction
    ).user
  }
  let(:jurisdiction) { create :jurisdiction }
  let(:proposed_law) {
    create :proposed_law, jurisdiction: jurisdiction, user: owner
  }

end
