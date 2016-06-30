require 'rails_helper'

RSpec.describe AdoptedLaw, type: :model do
  let( :adopted_law ) { build :adopted_law }

  it 'should save with valid attributes' do
    adopted_law.save!
    expect( adopted_law.year_adopted ).to eql Time.zone.today.year
    expect( adopted_law.number_in_year ).to eql 1
  end

  it "should assign correct number to a second law in same year for same jurisdiction" do
    adopted_law.save!
    second_law = build :adopted_law, proposed_law: build( :proposed_law,
      jurisdiction: adopted_law.proposed_law.jurisdiction )
    expect( second_law.year_adopted ).to be nil
    expect( second_law.number_in_year ).to be nil
    second_law.save!
    expect( second_law.year_adopted ).to eql adopted_law.year_adopted
    expect( second_law.number_in_year ).to eql 2
  end

  it "should not save without adopted_on date", focus: true do
    adopted_law.adopted_on = nil
    expect( adopted_law.save ).to be false
    expect( adopted_law.errors[:adopted_on] ).to include "can't be blank"
  end

  it "should not save with adopted_on date in the future" do
    adopted_law.adopted_on = Time.zone.today + 1.day
    expect( adopted_law.save ).to be false
    expect( adopted_law.errors[:adopted_on] ).to include "may not be in the future"
  end

  context 'in jurisdiction with elected executive' do
    let( :adopted_law ) { build :executive_adopted_law }
    it 'should save with valid attributes' do
      adopted_law.save!
    end

    it "should not save without executive_action_on" do
      adopted_law.executive_action_on = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:executive_action_on] ).to include "can't be blank"
    end

    it "should not save with executive_action_on that is later than adopted_on date" do
      adopted_law.executive_action_on = adopted_law.adopted_on + 1.day
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:executive_action_on] ).to include "may not be after date of final adoption"
    end

    it "should not save without executive_action" do
      adopted_law.executive_action = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:executive_action] ).to include "can't be blank"
    end

    it "should not save with invalid executive_action" do
      adopted_law.executive_action = 'blah'
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:executive_action] ).to include "is not included in the list"
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

    it "should not save with invalid referendum_type" do
      adopted_law.referendum_type = 'blah'
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:referendum_type] ).to include "is not included in the list"
    end

    it "should not save without election_type" do
      adopted_law.election_type = nil
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:election_type] ).to include "can't be blank"
    end

    it "should not save with invalid election_type" do
      adopted_law.election_type = 'blah'
      expect( adopted_law.save ).to be false
      expect( adopted_law.errors[:election_type] ).to include "is not included in the list"
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
