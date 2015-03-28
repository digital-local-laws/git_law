require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  context "validations" do
    it "should not save without an email" do
      user.email = nil
      expect( user.save ).to be false
      expect( user.errors[:email].first ).to include "can't be blank"
    end
  end
end
