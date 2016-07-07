require 'rails_helper'

RSpec.describe ProposedLaws::NodesController, type: :controller do
  include_context 'authorization'

  let(:proposed_law_node) {
    proposed_law.working_repo
    node = proposed_law.working_file('city-charter.json').node
    node.attributes['title'] = 'City Charter'
    expect( node.save ).to be true
    node
  }
  let(:proposed_law_nodes) {
    proposed_law.working_repo
    nodes = [
      proposed_law.working_file('gamma.json').node,
      proposed_law.working_file('beta.json').node,
      proposed_law.working_file('alpha.json').node
    ]
    nodes.each do |node|
      node.attributes['title'] = node.tree.gsub( /\.json$/, '' )
      expect( node.save ).to be true
    end
    nodes
  }
  def listing
    proposed_law.working_file('').node.child_nodes
  end

  before(:each) do
    proposed_law.working_repo
    default_params.merge! id: proposed_law.id
  end

  describe 'GET /api/proposed_laws/:id/nodes/*tree_base' do
    render_views

    before(:each) do
      controller.prepend_view_path 'app/views'
    end

    it 'should display nodes in correct order' do
      proposed_law_nodes
      get :index, default_params
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'proposed_laws/nodes/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 5
      expect( results.first['attributes']['title'] ).to eql 'alpha'
    end

    it "should return 404 error if queried node does not exist" do
      proposed_law_node
      get :index, default_params.merge( tree_base: 'omega.json' )
      expect( response ).to have_http_status 404
    end
  end

  describe 'GET /api/proposed_laws/:id/node/*tree_base' do
    render_views

    before(:each) do
      controller.prepend_view_path 'app/views'
    end

    it "should display an existing node" do
      get :show, default_params.merge( tree_base: proposed_law_node.tree_base )
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'proposed_laws/nodes/show'
    end

    it "should return a 404 error if node does not exist" do
      get :show, default_params.merge( tree_base: 'omega.json' )
      expect( response ).to have_http_status 404
    end
  end

  describe 'DELETE /api/proposed_laws/:id/node/*tree_base' do
    before(:each) {
      default_params.merge! tree_base: proposed_law_node.tree_base
    }

    it 'should delete a node with authorization' do
      token_sign_in owner
      delete :destroy, default_params
      expect( response ).to have_http_status 204
      list = proposed_law.working_file('').node.child_nodes.select do |node|
        node.tree_base == proposed_law_node.tree_base
      end
      expect( list ).to be_empty
    end

    it 'should not delete a node without authorization' do
      token_sign_in user
      delete :destroy, default_params
      expect( response ).to have_http_status 403
    end

    it 'should not delete a node without authentication' do
      delete :destroy, default_params
      expect( response ).to have_http_status 401
    end
  end

  describe 'PATCH /api/proposed_laws/:id/node/*tree_base' do
    before(:each) {
      default_params.merge! tree_base: proposed_law_node.tree_base
    }

    it 'should update a node for authorized user' do
      token_sign_in owner
      patch :update, default_params.merge( {
        attributes: {
          title: 'city charter'
        }
      } )
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'proposed_laws/nodes/show'
      node = proposed_law.working_file(proposed_law_node.tree).node
      expect( node.attributes['title'] ).to eql 'city charter'
    end

    it 'should not update a node without authorization' do
      token_sign_in user
      patch :update, default_params
      expect( response ).to have_http_status 403
    end

    it 'should not update a node without authentication' do
      patch :update, default_params
      expect( response ).to have_http_status 401
    end
  end

  describe 'POST /api/proposed_laws/:id/nodes/*tree_base' do
    let(:valid_params) {
      {
        tree_base: 'city-code',
        attributes: {
          title: 'City Code'
        }
      }
    }

    it 'should create a node with authorization' do
      token_sign_in owner
      listing.each do |n|
        expect( n.attributes['title'] ).not_to eql 'City Code'
      end
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 201
      expect( response ).to render_template 'proposed_laws/nodes/show'
      list = listing.select do |n|
        n.attributes['title'] == 'City Code'
      end
      expect( list.length ).to eql 1
    end

    it "should not create a node with invalid attribute" do
      token_sign_in owner
      post( :create, default_params.merge( valid_params ).merge(
        tree_base: proposed_law_node.tree_base
      ) )
      expect( response ).to have_http_status 422
      expect( response ).to render_template 'proposed_laws/nodes/errors'
    end

    it 'should not create a node without authorization' do
      token_sign_in user
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 403
    end

    it 'should not create a node without authentication' do
      post :create, default_params.merge( valid_params )
      expect( response ).to have_http_status 401
    end
  end
end
