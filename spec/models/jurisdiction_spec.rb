require "rails_helper"

RSpec.describe Jurisdiction, type: :model do
  context "validation" do
    it "should not save without a name" do
      jurisdiction = build(:jurisdiction, name: nil)
      expect( jurisdiction.save ).to be false
      expect( jurisdiction.errors[:name].first ).to include "can't be blank"
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
