require 'rails_helper'

RSpec.describe ProposedLawsController, type: :controller do
  include_context 'authorization'

  let(:proposed_laws) {
    [
      create( :proposed_law, jurisdiction: jurisdiction,
        title: 'Number 3: Fire Suppression', user: proposer ),
      create( :proposed_law, jurisdiction: jurisdiction,
        title: 'Number 2: Police', user: proposer ),
      create( :proposed_law, jurisdiction: jurisdiction,
        title: 'Number 1: Zoning', user: proposer )
    ]
  }

  describe 'GET /api/proposed_laws' do
    render_views

    before(:each) do
      controller.prepend_view_path 'app/views'
    end

    it 'should display proposed_laws in correct order' do
      proposed_laws
      get :index, default_params
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'proposed_laws/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 3
      expect( results.first['title'] ).to eql 'Number 1: Zoning'
    end

    it 'should return only matching results for query' do
      proposed_laws
      get :index, default_params.merge(q: 'suppression')
      results = JSON.parse( response.body )
      expect( results.length ).to eql 1
      expect( results.first['title'] ).to eql 'Number 3: Fire Suppression'
    end

    it 'should raise a 404 status if an empty page is turned that is not page 1' do
      get :index, default_params.merge( page: 2 )
      expect( response ).to have_http_status 404
    end
  end

  describe 'DELETE /api/proposed_laws/:id' do
    it 'should delete a proposed_law' do
      token_sign_in owner
      delete :destroy, default_params.merge( id: proposed_law.id )
      expect( response ).to have_http_status 204
      expect( ProposedLaw.where( id: proposed_law.id ).any? ).to be false
    end

    it 'should not delete a user without authorization' do
      token_sign_in user
      delete :destroy, default_params.merge( id: proposed_law.id )
      expect( response ).to have_http_status 401
    end

    it 'should not delete a user without authentication' do
      delete :destroy, default_params.merge( id: proposed_law.id )
      expect( response ).to have_http_status 401
    end
  end

  describe 'PATCH /api/proposed_laws/:id' do
    it 'should update a proposed_law for authorized user' do
      token_sign_in owner
      patch :update, default_params.merge( {
        id: proposed_law.id,
        title: 'Some different law title'
      } )
      expect( response ).to have_http_status 204
      proposed_law.reload
      expect( proposed_law.title ).to eql 'Some different law title'
    end

    it 'should not update a proposed_law without authorization' do
      token_sign_in user
      patch :update, default_params.merge( { id: proposed_law.id } )
      expect( response ).to have_http_status 401
    end

    it 'should not update a proposed_law without authentication' do
      patch :update, default_params.merge( { id: proposed_law.id } )
      expect( response ).to have_http_status 401
    end
  end

  describe 'POST /api/jurisdiction/:jurisdiction_id/proposed_laws' do
    let(:valid_params) {
      {
        title: 'A law that does something',
        jurisdiction_id: jurisdiction.id
      }
    }
    it 'should create a proposed_law with authorization' do
      token_sign_in proposer
      expect( ProposedLaw.where(title: 'A law that does something') ).to be_empty
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 201
      expect( response ).to render_template 'proposed_laws/show'
      expect( ProposedLaw.where(title: 'A law that does something') ).not_to be_empty
    end

    it 'should not create a proposed_law without authorization' do
      token_sign_in user
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 401
    end

    it 'should not create a proposed_law without authentication' do
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 401
    end
  end
end
