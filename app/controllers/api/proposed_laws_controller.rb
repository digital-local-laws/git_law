module Api
  class ProposedLawsController < ApplicationController
    before_filter :decamelize_params!
    expose :proposed_law do
      if params[:id]
        ProposedLaw.find params[:id]
      else
        code.proposed_laws.build( user: current_user )
      end
    end
    expose :code do
      if params[:code_id]
        Code.find params[:code_id]
      end
    end
    expose( :unpaginated_proposed_laws ) do
      if code
        code.proposed_laws.all
      else
        ProposedLaw.all
      end
    end
    helper_method :proposed_laws
    helper_method :code
    
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
      proposed_law.attributes = proposed_law_params
      respond_to do |format|
        format.json do
          if proposed_law.save
            render 'show', status: 201
          else
            render 'errors', status: 422
          end
        end
      end
    end
    
    def update
      proposed_law.attributes = proposed_law_params
      respond_to do |format|
        format.json do
          if proposed_law.save
            render nothing: true, status: 204
          else
            render 'errors', status: 422
          end
        end
      end
    end
    
    def destroy
      respond_to do |format|
        format.json do
          if proposed_law.destroy
            render nothing: true, status: 204
          else
            render nothing: true, status: 500
          end
        end
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
  end
end
