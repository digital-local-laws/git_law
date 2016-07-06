require 'rails_helper'

RSpec.describe GitlabClientIdentityRequest, type: :model do
  let(:request) { build :gitlab_client_identity_request }

  it 'should save with correct entries' do
    request.save!
  end

  it "should be invalid without 'host'" do
    request.host = nil
    expect( request.valid? ).to be false
    expect( request.errors[:host] ).to include "can't be blank"
  end

  it "should be invalid with improperly formatted 'host' parameter" do
    request.host = '0'
    expect( request.save ).to be false
    expect( request.errors[:host] ).to include "is invalid"
  end

  it "should be invalid without 'app_id'" do
    request.app_id = nil
    expect( request.valid? ).to be false
    expect( request.errors[:app_id] ).to include "can't be blank"
  end

  it "should be invalid with duplicate app_id" do
    request.save!
    duplicate = build :gitlab_client_identity_request, host: request.host,
      user: request.user, app_id: request.app_id
    expect( duplicate.save ).to be false
    expect( duplicate.errors[:app_id] ).to include "has already been taken"
  end

  it "should be invalid without 'app_secret'" do
    request.app_secret = nil
    expect( request.valid? ).to be false
    expect( request.errors[:app_secret] ).to include "can't be blank"
  end

  describe 'authorization_uri' do

    let ( :request_uri ) { "https://localhost/?gitlab_client_request_id=#{request.id}" }

    it "should return valid authorization_uri_query" do
      request.save!
      expect( request.authorization_uri_query( request_uri ) ).to eql(
        "client_id=#{request.app_id}&response_type=code&redirect_uri=#{CGI::escape request_uri}"
      )
    end

    it "should return valid authorization_uri" do
      request.save!
      expect( request.authorization_uri( request_uri ).to_s ).to eql(
        "https://#{request.host}/oauth/authorize?#{request.authorization_uri_query(request_uri)}"
      )
    end
  end
end
