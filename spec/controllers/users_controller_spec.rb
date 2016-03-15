require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create :user, admin: true }
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
      token_sign_in user
      users
      get :index, user_context
      expect( response ).to have_http_status 200
      expect( response ).to render_template 'users/index'
      results = JSON.parse( response.body )
      expect( results.length ).to eql 4
      expect( results.first['first_name'] ).to eql 'John'
    end

    it 'should return only matching results for query' do
      token_sign_in user
      users
      get :index, user_context.merge( q: 'warren' )
      results = JSON.parse( response.body )
      expect( results.length ).to eql 3
      expect( results.first['first_name'] ).to eql 'Earl'
    end

    it 'should raise a 404 status if an empty page is turned that is not page 1' do
      token_sign_in user
      get :index, user_context.merge( page: 2 )
      expect( response ).to have_http_status 404
    end
  end

  describe 'DELETE /api/users/:id' do
    it 'should delete a user' do
      token_sign_in user
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
      token_sign_in user
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
      token_sign_in create(:user)
      patch :update, user_context.merge( { id: users.first.id } )
      expect( response ).to have_http_status 401
    end

    it 'should not update a user without authentication' do
      patch :update, user_context.merge( { id: users.first.id } )
      expect( response ).to have_http_status 401
    end
  end
end
