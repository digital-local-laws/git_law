require "rails_helper"

RSpec.describe Code, type: :model do
  context "validation" do
    it "should not save without a name" do
      code = build(:code, name: nil)
      expect( code.save ).to be false
      expect( code.errors[:name].first ).to include "can't be blank"
    end
    it "should not save a duplicate name" do
      code = create(:code)
      code2 = build(:code, name: code.name)
      expect( code2.save ).to be false
      expect( code2.errors[:name].first ).to include "has already been taken"
    end
    it "should properly format a file_name" do
      code = create(:code, name: " Tompkins  County Code ")
      expect( code.file_name ).to eq "tompkins-county-code"
    end
  end
  context "repositories" do
    let(:code) { create :code }
    it "should initialize a canonical repo with repo()" do
      expect( File.exist?(code.repo_path) ).to be false
      code.repo
      expect( File.exist?(code.repo_path) ).to be true
    end
    it "should create a canonical working directory with working_repo()" do
      expect( File.exist?(code.working_repo_path) ).to be false
      code.working_repo
      expect( File.exist?(code.working_repo_path) ).to be true
    end
  end
end
