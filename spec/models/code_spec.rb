require "rails_helper"

RSpec.describe Code, type: :model do
  context "basic" do
    it "should not save without a name" do
      code = build(:code, name: nil)
      expect( code.save ).to be false
      expect( code.errors[:name].first ).to include "can't be blank"
    end
  end
end
