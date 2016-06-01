require "rails_helper"

RSpec.describe Jurisdiction, type: :model do
  let(:jurisdiction) { create :jurisdiction }

  context "validation" do
    it "should not save without a name" do
      jurisdiction.name = nil
      expect( jurisdiction.save ).to be false
      expect( jurisdiction.errors[:name].first ).to include "can't be blank"
    end

    it "should not save with executive_review setting" do
      expect( jurisdiction.executive_review ).to be false
      jurisdiction.executive_review = nil
      expect( jurisdiction.save ).to be false
      expect( jurisdiction.errors[:executive_review] ).to include "is not included in the list"
    end

    it "should not save without a legislative body" do
      jurisdiction.legislative_body = nil
      expect( jurisdiction.save ).to be false
      expect( jurisdiction.errors[:legislative_body] ).to include "can't be blank"
    end

    it "should not save a duplicate name" do
      jurisdiction = create(:jurisdiction)
      jurisdiction2 = build(:jurisdiction, name: jurisdiction.name)
      expect( jurisdiction2.save ).to be false
      expect( jurisdiction2.errors[:name].first ).to include "has already been taken"
    end

    it "should properly format a file_name" do
      jurisdiction = create(:jurisdiction, name: " Tompkins  County Jurisdiction ")
      expect( jurisdiction.file_name ).to eq "tompkins-county-jurisdiction"
    end
  end
  it_should_behave_like "a git flow repo"
end
