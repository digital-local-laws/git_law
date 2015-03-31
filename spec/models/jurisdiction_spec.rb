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
  context "repositories" do
    let(:jurisdiction) { create :jurisdiction }
    it "should initialize a canonical repo with repo()" do
      expect( File.exist?(jurisdiction.repo_path) ).to be false
      jurisdiction.repo
      expect( File.exist?(jurisdiction.repo_path) ).to be true
    end
    it "should create a canonical working directory with working_repo()" do
      expect( File.exist?(jurisdiction.working_repo_path) ).to be false
      jurisdiction.working_repo
      expect( File.exist?(jurisdiction.working_repo_path) ).to be true
    end
  end
end
