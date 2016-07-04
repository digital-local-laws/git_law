require 'rails_helper'

RSpec.describe GitlabClientIdentity, type: :model do
  let(:identity) { build :gitlab_client_identity }

  it 'should save with valid attributes' do
    identity.save!
  end

  it 'should not save with missing user' do
    identity.user = nil
    expect( identity.save ).to be false
    expect( identity.errors[:user] ).to include "can't be blank"
  end

  it 'should not save with missing gitlab_user_id' do
    allow( identity ).to receive(:initialize_gitlab_user_id) { }
    identity.gitlab_user_id = nil
    expect( identity.save ).to be false
    expect( identity.errors[:gitlab_user_id] ).to include "can't be blank"
  end

  it 'should not save with missing host' do
    identity.host = nil
    expect( identity.save ).to be false
    expect( identity.errors[:host] ).to include "can't be blank"
  end

  it 'should not save with missing access_token' do
    identity.access_token = nil
    expect( identity.save ).to be false
    expect( identity.errors[:access_token] ).to include "can't be blank"
  end

  it 'should not save with a duplicate identity' do
    identity.save!
    duplicate = build :gitlab_client_identity, user: identity.user,
      gitlab_user_id: identity.gitlab_user_id
    expect( duplicate.save ).to be false
    expect( duplicate.errors[:gitlab_user_id] ).to include "has already been taken"
  end

  it 'should not save with a duplicate token' do
    identity.save!
    duplicate = build :gitlab_client_identity, user: identity.user,
      access_token: identity.access_token
    expect( duplicate.save ).to be false
    expect( duplicate.errors[:access_token] ).to include "has already been taken"
  end
end
