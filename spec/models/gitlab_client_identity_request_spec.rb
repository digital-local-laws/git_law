require 'rails_helper'

RSpec.describe GitlabClientIdentityRequest, type: :model do
  let(:request) { build :gitlab_client_identity_request }

  it 'should be valid with correct entries' do
    expect( request.valid? ).to be true
  end

  it "should be invalid without 'host'" do
    request.host = nil
    expect( request.valid? ).to be false
    expect( request.errors[:host] ).to include "can't be blank"
  end

  it "should be invalid without 'client_id'" do
    request.client_id = nil
    expect( request.valid? ).to be false
    expect( request.errors[:client_id] ).to include "can't be blank"
  end

  it "should be invalid without 'client_secret'" do
    request.client_secret = nil
    expect( request.valid? ).to be false
    expect( request.errors[:client_secret] ).to include "can't be blank"
  end
end
