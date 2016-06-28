require 'rails_helper'

RSpec.describe AdoptedLawsController, type: :controller do
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

  let(:adopted_laws) {
    proposed_laws.map do |proposed_law|
      create :adopted_law, proposed_law: proposed_law
    end
  }

  describe 'GET /api/adopted_laws' do
    render_views

    before(:each) do
      controller.prepend_view_path 'app/views'
    end

    it 'should display adopted_laws in correct order' do
      adopted_laws
      get :index, default_params
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'adopted_laws/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 3
      expect( results.first['proposed_law']['title'] ).to eql 'Number 1: Zoning'
    end

    it 'should return only matching results for query' do
      adopted_laws
      get :index, default_params.merge(q: 'suppression')
      results = JSON.parse( response.body )
      expect( results.length ).to eql 1
      expect( results.first['proposed_law']['title'] ).to eql 'Number 3: Fire Suppression'
    end

    it 'should raise a 404 status if an empty page is turned that is not page 1' do
      get :index, default_params.merge( page: 2 )
      expect( response ).to have_http_status 404
    end
  end

  describe 'POST /api/proposed_law/:proposed_law_id/adopted_laws' do
    let(:valid_params) {
      {
        proposed_law_id: proposed_laws[0].id
      }
    }

    it 'should create an adopted_law with authorization' do
      token_sign_in adopter
      expect( AdoptedLaw.where(proposed_law_id: proposed_laws[0].id) ).to be_empty
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 201
      expect( response ).to render_template 'adopted_laws/show'
      expect( AdoptedLaw.where(proposed_law_id: proposed_laws[0].id) ).not_to be_empty
    end

    it 'should not create an adopted_law without authorization' do
      token_sign_in user
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 401
    end

    it 'should not create an adopted_law without authentication' do
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 401
    end
  end
end
