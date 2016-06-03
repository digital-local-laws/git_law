class JurisdictionsController < ApplicationController
  before_filter :decamelize_params!
  before_action :authenticate_user!, :authorize_user!, except: [ :index, :show ]

  expose :jurisdiction
  expose( :unpaginated_jurisdictions ) do
    s = Jurisdiction.order :name
    if params[:q]
      s.where "name ILIKE ?", "%#{params[:q]}%"
    else
      s
    end
  end
  helper_method :jurisdictions, :jurisdiction

  def index
    if page == 1 || jurisdictions.any?
      render status: 200
    else
      render nothing: true, status: 404
    end
  end

  def show
    render status: 200
  end

  def create
    jurisdiction.attributes = jurisdiction_params
    if jurisdiction.save
      render 'show', status: 201, location: jurisdiction
    else
      render 'errors', status: 422
    end
  end

  def update
    jurisdiction.attributes = jurisdiction_params
    if jurisdiction.save
      render nothing: true, status: 204
    else
      render 'errors', status: 422
    end
  end

  def destroy
    if jurisdiction.destroy
      render nothing: true, status: 204
    else
      render nothing: true, status: 500
    end
  end

  private

  def authorize_user!
    authorize jurisdiction
  end

  def jurisdictions
    @jurisdictions ||= paginate unpaginated_jurisdictions
  end

  def jurisdiction_params
    @jurisdiction_params ||= params.
      permit(:name,:executive_review,:legislative_body,:government_type)
  end
end
