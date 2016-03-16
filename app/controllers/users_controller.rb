class UsersController < ApplicationController
  before_action :authenticate_user!

  expose :unpaginated_users do
    s = User.all
    if params[:q]
      s.name_like params[:q]
    else
      s
    end
  end
  expose :users do
    paginate unpaginated_users
  end
  expose :user
  expose :page do
    params[:page] ? params[:page].to_i : 1
  end
  expose :user_attributes do
    params.permit :first_name, :last_name, :admin, :staff, :email, :password,
      :password_confirmation
  end

  # GET /api/users[/page/:page].json[?q=:q]
  def index
    authorize User, :index?
    if page == 1 || users.any?
      render 'index', status: 200
    else
      render nothing: true, status: 404
    end
  end

  # GET /api/users/:id(.:format)
  def show
    authorize user, :show?
    render 'show', status: 200
  end

  # POST /api/users(.:format)
  def create
    authorize User, :create?
    user.attributes = user_attributes
    user.skip_confirmation!
    if user.save
      render 'show', status: 201, location: user
    else
      render 'errors', status: 422
    end
  end

  # DELETE /api/users/:id(.:format)
  def destroy
    authorize user, :destroy?
    if user.destroy
      render nothing: true, status: 204
    else
      render nothing: true, status: 500
    end
  end

  # PATCH /api/users/:id(.:format)
  def update
    authorize user, :update?
    user.attributes = user_attributes
    if user.save
      render nothing: true, status: 204
    else
      render 'errors', status: 422
    end
  end
end
