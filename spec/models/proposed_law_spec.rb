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

    let(:proposed_law_node) { repo.working_file('proposed-law.json').node }

    let(:pl_root_node) { repo.working_file('proposed-law/section-1.json').node }
    let(:pl_middle_node) { repo.working_file('proposed-law/section-2.json').node }
    let(:pl_leaf_node) { repo.working_file('proposed-law/section-3.json').node }

    it "should have basic metadata when law is created" do
      expect( proposed_law_node.exists? ).to be true
    end

    it 'should create new linked node when root node added' do
      root_node
      expect( pl_root_node.exists? ).to be true
      expect( pl_root_node.attributes["number"] ).to eql "1"
      expect( pl_root_node.attributes["title"] ).to eql root_node.attributes["title"]
      expect( pl_root_node.attributes["link"] ).to eql root_node.tree
    end

    it 'should create new linked node when middle node added' do
      middle_node
      expect( pl_middle_node.exists? ).to be true
      expect( pl_middle_node.attributes["number"] ).to eql "2"
      expect( pl_middle_node.attributes["title"] ).to eql middle_node.attributes["title"]
      expect( pl_middle_node.attributes["link"] ).to eql middle_node.tree
    end

    it 'should create new linked node when leaf node added' do
      leaf_node
      expect( pl_leaf_node.exists? ).to be true
      expect( pl_leaf_node.attributes["number"] ).to eql "3"
      expect( pl_leaf_node.attributes["title"] ).to eql leaf_node.attributes["title"]
      expect( pl_leaf_node.attributes["link"] ).to eql leaf_node.tree
    end

    context 'with intrinsic node in proposed law node' do
      let( :intrinsic_node ) do
        node = repo.working_file("proposed-law/section-1.json").node
        node.create
        node
      end

      it 'should not create another linked node' do
        intrinsic_node
        expect( repo.working_file("proposed-law/section-1.json").exists? ).to be true
        expect( repo.working_file("proposed-law/section-2.json").exists? ).to be false
        expect( intrinsic_node.attributes["link"] ).to be nil
      end
    end
  end
end
