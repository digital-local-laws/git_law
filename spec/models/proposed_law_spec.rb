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
  it_should_behave_like "a git flow node repo"

  context "proposed law metadata" do
    include_context 'a structured git flow node'

    let(:proposed_law_node) { repo.working_file('proposed-law.adoc').node }

    let(:pl_root_node) { repo.working_file('proposed-law/section-1.adoc').node }
    let(:pl_middle_node) { repo.working_file('proposed-law/section-2.adoc').node }
    let(:pl_leaf_node) { repo.working_file('proposed-law/section-3.adoc').node }

    it "should have basic metadata when law is created" do
      expect( proposed_law_node.exists? ).to be true
    end
  end
end
