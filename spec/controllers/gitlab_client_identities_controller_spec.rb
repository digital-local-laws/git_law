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
  let(:gitlab_client_identity_request) {
    create :gitlab_client_identity_request, user: owner
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
      expect( response ).to have_http_status 403
    end

    it 'should not delete a gitlab identity without authentication' do
      delete :destroy, default_params.merge( id: gitlab_client_identity.id )
      expect( response ).to have_http_status 401
    end
  end

  describe 'POST /api/gitlab_client_identity_requests/:gitlab_client_request_id/gitlab_client_identities' do
    render_views

    let(:valid_params) {
      {
        gitlab_client_identity_request_id: gitlab_client_identity_request.id,
        code: 'thetoken'
      }
    }

    before(:each) do
      controller.prepend_view_path 'app/views'
      Struct.new( "User", :id, :username )
      gitlab_user = Struct::User.new(
        1,
        'auser'
      )
      allow_any_instance_of( GitlabClientIdentity ).to receive(:obtain_access_token).and_return('noneofyourbusiness')
      allow_any_instance_of( GitlabClientIdentity ).to receive(:gitlab_user).and_return(gitlab_user)
      token_sign_in owner
    end

    after(:each) do
      Struct.send(:remove_const,:User)
    end

    it 'should create a gitlab_client_identity with authorization' do
      expect( owner.gitlab_client_identities ).to be_empty
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 201
      expect( response ).to render_template 'gitlab_client_identities/show'
    end

    it "should raise an error with invalid parameters", focus: true do
      valid_params.delete :code
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 422
      expect( JSON.parse( response.body )['errors']['code'] ).to include "can't be blank"
    end
  end
end
