RSpec.shared_context 'authorization' do
  let(:user) { create :user }
  let(:admin) { create :user, admin: true }
  let(:staff) { create :user, staff: true }
end
