class UserSessionController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [ :create, :destroy ]
  
  def show
    respond_to do |format|
      format.json do
        if current_user
          render 'show', status: 200
        else
          render json: { }, status: 200
        end
      end
    end
  end

  def create
    if user = User.find_or_create_by(email: auth['info']['email'])
      reset_session
      self.current_user = user
      respond_to do |format|
        format.html { redirect_to '/' }
        format.json { render 'show', status: 201 }
      end
    else
      respond_to do |format|
        # TODO better error handling
        format.html { render nothing: true, status: 500 }
        format.json { render nothing: true, status: 500 }
      end
    end
  end
  
  def destroy
    reset_session
    respond_to do |format|
      format.html { redirect_to '/' }
      format.json { render nothing: true, status: 204 }
    end
  end
  
  private
  
  def auth
    request.env['omniauth.auth']
  end
end
