require 'rails_helper'

RSpec.describe JurisdictionsController, type: :controller do
  include_context 'authorization'

  let(:jurisdiction) { create :jurisdiction }
  let(:jurisdictions) {
    [
      create( :jurisdiction, name: 'Syracuse' ),
      create( :jurisdiction, name: 'Ithaca' ),
      create( :jurisdiction, name: 'Binghamton' )
    ]
  }

  describe 'GET /api/jurisdictions' do
    render_views

    before(:each) do
      controller.prepend_view_path 'app/views'
    end

    it 'should display jurisdictions in correct order' do
      jurisdictions
      get :index
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'jurisdictions/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 3
      expect( results.first['name'] ).to eql 'Binghamton'
    end

    it 'should return only matching results for query' do
      jurisdictions
      get :index, default_params.merge( q: 'bing' )
      results = JSON.parse( response.body )
      expect( results.length ).to eql 1
      expect( results.first['name'] ).to eql 'Binghamton'
    end

    it 'should raise a 404 status if an empty page is turned that is not page 1' do
      get :index, default_params.merge( page: 2 )
      expect( response ).to have_http_status 404
    end
  end

  describe 'DELETE /api/jurisdictions/:id' do
    it 'should delete a jurisdiction' do
      token_sign_in admin
      delete :destroy, default_params.merge( id: jurisdiction.id )
      expect( response ).to have_http_status 204
      expect( Jurisdiction.where( id: jurisdiction.id ).any? ).to be false
    end

    it 'should not delete a user without authorization' do
      token_sign_in user
      delete :destroy, default_params.merge( id: jurisdiction.id )
      expect( response ).to have_http_status 401
    end

    it 'should not delete a user without authentication' do
      delete :destroy, default_params.merge( id: jurisdiction.id )
      expect( response ).to have_http_status 401
    end
  end

  describe 'PATCH /api/jurisdictions/:id' do
    it 'should update a jurisdiction for authorized user' do
      token_sign_in staff
      patch :update, default_params.merge( {
        id: jurisdiction.id,
        name: 'Corning',
        legislative_body: 'Corning City Council',
        executive_review: true
      } )
      expect( response ).to have_http_status 204
      jurisdiction.reload
      expect( jurisdiction.name ).to eql 'Corning'
      expect( jurisdiction.legislative_body ).to eql 'Corning City Council'
      expect( jurisdiction.executive_review ).to be true
    end

    it 'should not update a jurisdiction without authorization' do
      token_sign_in user
      patch :update, default_params.merge( { id: jurisdiction.id } )
      expect( response ).to have_http_status 401
    end

    it 'should not update a jurisdiction without authentication' do
      patch :update, default_params.merge( { id: jurisdiction.id } )
      expect( response ).to have_http_status 401
    end
  end

  describe 'POST /api/jurisdictions' do
    let(:valid_params) {
      { name: 'Binghamton', legislative_body: 'Binghamton City Council',
        executive_review: true }
    }
    it 'should create a jurisdiction with authorization' do
      token_sign_in staff
      expect( Jurisdiction.where(name: 'Binghamton') ).to be_empty
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 201
      expect( response ).to render_template 'jurisdictions/show'
      jurisdiction = Jurisdiction.where(name: 'Binghamton').first
      expect( jurisdiction ).not_to be nil
      expect( jurisdiction.legislative_body ).to eql 'Binghamton City Council'
      expect( jurisdiction.executive_review ).to be true
    end

    it 'should not create a jurisdiction without authorization' do
      token_sign_in user
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 401
    end

    it 'should not create a jurisdiction without authentication' do
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 401
    end
  end
end
