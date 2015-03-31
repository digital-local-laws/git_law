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
  context "repositories" do
    let(:proposed_law) { create :proposed_law }
    it "should initialize a canonical repo with repo()" do
      expect( File.exist?(proposed_law.repo_path) ).to be false
      proposed_law.repo
      expect( File.exist?(proposed_law.repo_path) ).to be true
    end
    it "should create a canonical working directory with working_repo()" do
      expect( File.exist?(proposed_law.working_repo_path) ).to be false
      proposed_law.working_repo
      expect( File.exist?(proposed_law.working_repo_path) ).to be true
    end
  end
end
