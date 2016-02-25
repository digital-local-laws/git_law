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
      sign_in user
      jurisdictions
      get :index
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'jurisdictions/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 3
      expect( results.first['name'] ).to eql 'Binghamton'
    end
  end
end
