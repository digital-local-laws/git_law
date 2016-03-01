class ProposedLawsController < ApplicationController
  before_filter :decamelize_params!, :camelize_output!
  before_action :authenticate_user!, :authorize_user!, except: [ :index, :show ]

  expose :proposed_law do
    if params[:id]
      ProposedLaw.find params[:id]
    else
      jurisdiction.proposed_laws.build( user: current_user )
    end
  end
  expose :jurisdiction do
    if params[:jurisdiction_id]
      Jurisdiction.find params[:jurisdiction_id]
    end
  end
  expose( :unpaginated_proposed_laws ) do
    s = if jurisdiction
      jurisdiction.proposed_laws.all
    else
      ProposedLaw.all
    end
    s = s.order :title
    if params[:q]
      s.where "title ILIKE ?", "%#{params[:q]}%"
    else
      s
    end
  end
  helper_method :proposed_laws
  helper_method :jurisdiction

  def index
    if page == 1 || proposed_laws.any?
      render status: 200
    else
      render nothing: true, status: 404
    end
  end

  def show
    render status: 200
  end

  def create
    proposed_law.attributes = proposed_law_params
    if proposed_law.save
      render 'show', status: 201, location: proposed_law
    else
      render 'errors', status: 422
    end
  end

  def update
    proposed_law.attributes = proposed_law_params
    if proposed_law.save
      render nothing: true, status: 204
    else
      render 'errors', status: 422
    end
  end

  def destroy
    if proposed_law.destroy
      render nothing: true, status: 204
    else
      render nothing: true, status: 500
    end
  end

  private

  def authorize_user!
    authorize proposed_law
  end

  def proposed_laws
    @proposed_laws ||= paginate unpaginated_proposed_laws
  end

  def proposed_law_params
    @proposed_law_params ||= params.
      permit(:title)
  end

  def proposed_law_node_params
    allowed_params = [ :content, { metadata: [ :number, :title,
      { structure: [ [ :name, :number, :title, :optional ] ] } ] } ]
    @proposed_law_node_params ||= params.
      permit(*allowed_params)
  end
end
