require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include_context 'authorization'

  let(:users) { [
    create( :user, first_name: 'Warren', last_name: 'Zevon' ),
    create( :user, first_name: 'Earl', last_name: 'Warren' ),
    create( :user, first_name: 'Elizabeth', last_name: 'Warren' )
  ] }
  let(:user_context) {
    { format: 'json' }
  }

  describe "GET /api/users" do
    render_views

    before(:each) do
      controller.prepend_view_path 'app/views'
    end

    it 'should return all users in correct order' do
      token_sign_in admin
      users
      get :index, user_context
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'users/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 4
      expect( results.first['first_name'] ).to eql 'John'
    end

    it 'should return only matching results for query' do
      token_sign_in admin
      users
      get :index, user_context.merge( q: 'warren' )
      results = JSON.parse( response.body )
      expect( results.length ).to eql 3
      expect( results.first['first_name'] ).to eql 'Earl'
    end

    it 'should raise a 404 status if an empty page is turned that is not page 1' do
      token_sign_in admin
      get :index, user_context.merge( page: 2 )
      expect( response ).to have_http_status 404
    end
  end

  describe 'GET /api/users/:id' do
    it 'should display a user' do
      token_sign_in admin
      get :show, { id: user.id }
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'users/show'
    end

    it 'should raise an error for non-existent user record' do
      token_sign_in admin
      user.destroy
      get :show, { id: user.id }
      expect( response ).to have_http_status 404
    end

    it 'should raise an error for unprivileged user' do
      token_sign_in user
      get :show, { id: admin.id }
      expect( response ).to have_http_status 401
    end

    it 'should raise an error for unauthenticated user' do
      get :show, { id: user.id }
      expect( response ).to have_http_status 401
    end
  end

  describe 'POST /api/users/:id' do
    let(:valid_params) {
      user_context.merge( attributes_for :user ).
      merge( first_name: 'Al', last_name: 'Smith' )
    }
    it 'should create a user' do
      token_sign_in admin
      post :create, valid_params
      expect( response ).to have_http_status 201
      expect( User.count ).to eql 2
      expect( User.last.first_name ).to eql 'Al'
    end

    it 'should raise a 422 status if invalid entry provided' do
      token_sign_in admin
      valid_params.delete :last_name
      post :create, valid_params
      expect( response ).to have_http_status 422
    end

    it 'should raise a 401 status for unprivileged user' do
      token_sign_in user
      post :create, valid_params
      expect( response ).to have_http_status 401
    end

    it 'should raise a 401 status for unauthenticated user' do
      post :create, valid_params
      expect( response ).to have_http_status 401
    end
  end

  describe 'DELETE /api/users/:id' do
    it 'should delete a user' do
      token_sign_in admin
      delete :destroy, user_context.merge( { id: users.first.id } )
      expect( response ).to have_http_status 204
      expect( User.where( id: users.first.id ).any? ).to be false
    end

    it 'should not delete a user without authorization' do
      token_sign_in create(:user)
      delete :destroy, user_context.merge( { id: users.first.id } )
      expect( response ).to have_http_status 401
    end

    it 'should not delete a user without authentication' do
      delete :destroy, user_context.merge( { id: users.first.id } )
      expect( response ).to have_http_status 401
    end
  end

  describe 'PATCH /api/users/:id' do
    it 'should update a user' do
      token_sign_in admin
      patch :update, user_context.merge({ id: users.first.id,
        first_name: 'Dewitt', last_name: 'Clinton', admin: true,
        email: 'dclinton@example.com' })
      expect( response ).to have_http_status 204
      u = users.first
      u.reload
      expect( u.first_name ).to eql 'Dewitt'
      expect( u.last_name ).to eql 'Clinton'
      expect( u.email ).to eql 'dclinton@example.com'
      expect( u.admin ).to be true
    end

    it 'should not update a user without authorization' do
      token_sign_in user
      patch :update, user_context.merge( { id: users.first.id } )
      expect( response ).to have_http_status 401
    end

    it 'should not update a user without authentication' do
      patch :update, user_context.merge( { id: users.first.id } )
      expect( response ).to have_http_status 401
    end
  end
end
