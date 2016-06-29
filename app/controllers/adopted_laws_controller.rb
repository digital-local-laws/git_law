class AdoptedLawsController < ApplicationController
  before_filter :decamelize_params!, :camelize_output!
  before_action :authenticate_user!, :authorize_user!, except: [ :index, :show ]

  expose :adopted_law do
    if params[:id]
      AdoptedLaw.find params[:id]
    else
      proposed_law.build_adopted_law
    end
  end
  expose :proposed_law do
    ProposedLaw.find params[:proposed_law_id]
  end
  expose :jurisdiction do
    if params[:jurisdiction_id]
      Jurisdiction.find params[:jurisdiction_id]
    end
  end
  expose( :unpaginated_adopted_laws ) do
    scope = if jurisdiction
      jurisdiction.proposed_laws.all
    else
      AdoptedLaw.all
    end
    if params[:q]
      scope = scope.where "proposed_laws.title ILIKE ?", "%#{params[:q]}%"
    end
    scope.includes(:proposed_law).references(:proposed_law).
      order( 'proposed_laws.title ASC' )
  end
  helper_method :proposed_law, :adopted_law, :adopted_laws, :jurisdiction

  def index
    if page == 1 || adopted_laws.any?
      render status: 200
    else
      render nothing: true, status: 404
    end
  end

  def show
    render status: 200
  end

  def create
    adopted_law.attributes = adopted_law_params
    if adopted_law.save
      render 'show', status: 201, location: adopted_law
    else
      render 'errors', status: 422
    end
  end

  private

  def authorize_user!
    authorize adopted_law
  end

  def adopted_laws
    @adopted_laws ||= paginate unpaginated_adopted_laws
  end

  def adopted_law_params
    @adopted_law_params ||= params.
      permit(
        :executive_action, :executive_action_on, :referendum_required,
        :referendum_type, :permissive_petition, :election_type, :adopted_on
      )
  end
end
