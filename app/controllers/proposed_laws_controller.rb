class ProposedLawsController < ApiController
  before_filter :decamelize_params!, :camelize_output!
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
    if jurisdiction
      jurisdiction.proposed_laws.all
    else
      ProposedLaw.all
    end
  end
  helper_method :proposed_laws
  helper_method :jurisdiction

  def index
    render status: 200
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
