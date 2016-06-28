require 'rails_helper'

RSpec.describe AdoptedLaw, type: :model do
  let( :adopted_law ) { build :adopted_law }

  it 'should save with valid attributes' do
    adopted_law.save!
  end

  context 'in jurisdiction with elected executive' do
    let( :adopted_law ) { build :executive_adopted_law }
    it 'should save with valid attributes' do
      adopted_law.save!
    end

    it "should not save without executive_action_date" do
      adopted_law.executive_action_date = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:executive_action_date] ).to include "can't be blank"
    end

    it "should not save without executive_action" do
      adopted_law.executive_action = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:executive_action] ).to include "can't be blank"
    end
  end

  context 'subject to mandatory referendum' do
    let( :adopted_law ) { build :mandatory_referendum_adopted_law }
    it "should save with valid attributes" do
      adopted_law.save!
    end

    it "should not save without referendum_type" do
      adopted_law.referendum_type = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:referendum_type] ).to include "can't be blank"
    end

    it "should not save without election_type" do
      adopted_law.election_type = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:election_type] ).to include "can't be blank"
    end
  end

  context "subject to permissive referendum" do
    let( :adopted_law ) { build :permissive_referendum_adopted_law }
    it "should save with valid attributes" do
      adopted_law.save!
    end

    it "should save with no election held" do
      adopted_law.election_type = nil
      adopted_law.save!
    end

    it "should save with election held" do
      adopted_law.election_type = 'general'
      adopted_law.save!
    end

    it "should not save without election if a petition was received" do
      adopted_law.permissive_petition = true
      adopted_law.election_type = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:election_type] ).to include "can't be blank"
    end
  end

end
