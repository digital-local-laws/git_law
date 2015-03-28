require 'rails_helper'

RSpec.describe ProposedLaw, type: :model do
  let(:proposed_law) { build :proposed_law }
  context "Validations" do
    it "should not save without a title" do
      proposed_law.title = nil
      expect( proposed_law.save ).to be false
      expect( proposed_law.errors[:title].first ).to include "can't be blank"
    end
    it "should not save without a user" do
      proposed_law.user = nil
      expect( proposed_law.save ).to be false
      expect( proposed_law.errors[:user].first ).to include "can't be blank"
    end
    it "should not save without a code" do
      proposed_law.code = nil
      expect( proposed_law.save ).to be false
      expect( proposed_law.errors[:code].first ).to include "can't be blank"
    end
  end
end
