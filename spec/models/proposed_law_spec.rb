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
      expect( proposed_law.metadata.keys ).to eq( [ "structure", "sections" ] )
    end
    it "should have no sections" do
      expect( proposed_law.sections ).to be_empty
    end
    it "should write a properly inserted root section" do
      proposed_law.sections << ProposedLawSection.new(
        prefix: "section",
        number: "1",
        title: "Statement of Purpose"
      )
      proposed_law.write_metadata
      proposed_law.reset_metadata
      expect( proposed_law.sections.length ).to eq 1
      expect( proposed_law.sections.first.title ).to eq "Statement of Purpose"
    end
  end
end
