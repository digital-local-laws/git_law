require 'rails_helper'

RSpec.describe GitlabClientIdentityRequestsController, type: :controller do
  include_context 'authorization'

  let(:gitlab_client_identity_request) {
    create :gitlab_client_identity_request, user: owner
  }
  let(:valid_params) {
    {
      app_id: 'auser',
      app_secret: 'noneofyourbusiness',
      host: 'example.com',
      user_id: owner.id
    }
  }

  describe 'POST /api/user/:user_id/gitlab_client_identity_requests' do
    render_views

    before(:each) {
      controller.prepend_view_path 'app/views'
      default_params.merge! valid_params
    }

    it "should return an authorization url with valid parameters" do
      token_sign_in owner
      post :create, default_params
      expect( response ).to have_http_status 201
      results = JSON.parse( response.body )
      expect( results["authorization_uri"] ).to be_truthy
    end

    it "should return an error if required parameter is missing" do
      default_params.delete :app_id
      token_sign_in owner
      post :create, default_params
      expect( response ).to have_http_status 422
      results = JSON.parse( response.body )
      expect( results["app_id"] ).to include "can't be blank"
    end

    it "should return an error for unauthorized user" do
      token_sign_in user
      post :create, default_params
      expect( response ).to have_http_status 403
    end

    it "should return an error for unauthenticated user" do
      post :create, default_params
      expect( response ).to have_http_status 401
    end
  end
end
