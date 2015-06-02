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
    it "should not save without a jurisdiction" do
      proposed_law.jurisdiction = nil
      expect( proposed_law.save ).to be false
      expect( proposed_law.errors[:jurisdiction].first ).to include "can't be blank"
    end
  end
  it_should_behave_like "a git flow repo"
  context "law metadata" do
    let(:proposed_law) { create :proposed_law }
    before(:each) { proposed_law.working_repo }
    it "should have basic metadata" do
      expect( proposed_law.metadata.keys ).to eq( [ "sections" ] )
    end
  end
end
