require 'rails_helper'

RSpec.describe GitlabClientIdentitiesController, type: :controller do
  include_context 'authorization'

  let(:gitlab_client_identities) {
    [
      create( :gitlab_client_identity, user: owner, gitlab_user_id: 3 ),
      create( :gitlab_client_identity, user: owner, gitlab_user_id: 2 ),
      create( :gitlab_client_identity, user: owner, gitlab_user_id: 1 )
    ]
  }
  let(:gitlab_client_identity) {
    create :gitlab_client_identity, user: owner
  }
  let(:valid_new_params) {
    {
      client_id: 'auser',
      client_secret: 'noneofyourbusiness',
      host: 'example.com',
      user_id: owner.id
    }
  }

  describe 'GET /api/users/:user_id/gitlab_client_identities' do
    render_views

    before(:each) do
      controller.prepend_view_path 'app/views'
      default_params.merge! user_id: owner.id
    end

    it 'should display gitlab_client_identities in correct order' do
      token_sign_in owner
      gitlab_client_identities
      get :index, default_params
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'gitlab_client_identities/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 3
      expect( results.first['gitlab_user_id'] ).to eql 1
    end

    it 'should raise a 404 status if an empty page is turned that is not page 1' do
      token_sign_in owner
      get :index, default_params.merge( page: 2 )
      expect( response ).to have_http_status 404
    end

    it "should raise a 401 status if user is not authorized" do
      get :index, default_params
      expect( response ).to have_http_status 401
    end
  end

  describe 'DELETE /api/gitlab_client_identities/:id' do
    it 'should delete a proposed_law' do
      token_sign_in owner
      delete :destroy, default_params.merge( id: gitlab_client_identity.id )
      expect( response ).to have_http_status 204
      expect( GitlabClientIdentity.where( id: gitlab_client_identity.id ).any? ).to be false
    end

    it 'should not delete a gitlab identity without authorization' do
      token_sign_in user
      delete :destroy, default_params.merge( id: gitlab_client_identity.id )
      expect( response ).to have_http_status 401
    end

    it 'should not delete a gitlab identity without authentication' do
      delete :destroy, default_params.merge( id: gitlab_client_identity.id )
      expect( response ).to have_http_status 401
    end
  end

  describe 'GET /api/user/:user_id/gitlab_client_identities/new' do
    before(:each) {
      default_params.merge! valid_new_params
    }

    it "should return an authorization url with valid parameters" do
      token_sign_in owner
      get :new, default_params
      expect( response ).to have_http_status 200
      results = JSON.parse( response.body )
      expect( results["authorization_url"] ).to be_truthy
    end

    it "should return an error if required parameter is missing" do
      default_params.delete :client_id
      token_sign_in owner
      get :new, default_params
      expect( response ).to have_http_status 422
      results = JSON.parse( response.body )
      expect( results["client_id"] ).to include "can't be blank"
    end

    it "should return an error for unauthorized user" do
      token_sign_in user
      get :new, default_params
      expect( response ).to have_http_status 401
    end
  end

  describe 'POST /api/user/:user_id/gitlab_client_identities' do
    let(:valid_params) {
      {
        user_id: owner.id,
        code: 'thetoken'
      }
    }

    before(:each) do
      token_sign_in owner
      get :new, default_params.merge( valid_new_params )
      Struct.new( "Response", :code, :body )
      response = Struct::Response.new(
        200,
        JSON.generate( "access_token" => "noneofyourbusiness" )
      )
      allow( ::RestClient ).to receive(:post).and_return( response )
    end

    it 'should create a gitlab_client_identity with authorization' do
      expect( owner.gitlab_client_identities ).to be_empty
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 201
      expect( response ).to render_template 'gitlab_client_identities/show'
    end
  end
end
