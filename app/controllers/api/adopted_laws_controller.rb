module Api
  class AdoptedLawsController < ApiController
    before_filter :decamelize_params!, :camelize_output!
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
      if jurisdiction
        jurisdiction.proposed_laws.all
      else
        AdoptedLaw.all
      end
    end
    helper_method :proposed_law
    helper_method :adopted_laws
    helper_method :jurisdiction

    def index
      respond_to do |format|
        format.json { render 'index', status: 200 }
      end
    end

    def show
      respond_to do |format|
        format.json { render 'show', status: 200 }
      end
    end

    def create
      adopted_law.attributes = adopted_law_params
      respond_to do |format|
        format.json do
          if adopted_law.save
            render 'show', status: 201
          else
            render 'errors', status: 422
          end
        end
      end
    end

    private

    def adopted_laws
      @adopted_laws ||= paginate unpaginated_adopted_laws
    end

    def adopted_law_params
      @adopted_law_params ||= params.
        permit(:certification_type)
    end
  end
end
