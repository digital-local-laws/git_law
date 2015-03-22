module Api
  class CodesController < ApplicationController
    before_filter :decamelize_params!
    expose :code
    expose( :unpaginated_codes ) { Code.order(:name) }
    helper_method :codes
    
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
      code.attributes = code_params
      respond_to do |format|
        format.json do
          if code.save
            render 'show', status: 201
          else
            render 'errors', status: 422
          end
        end
      end
    end
    
    def update
      code.attributes = code_params
      respond_to do |format|
        format.json do
          if code.save
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
          if code.destroy
            render nothing: true, status: 204
          else
            render nothing: true, status: 500
          end
        end
      end
    end
        
    private
    
    def codes
      @codes ||= paginate unpaginated_codes
    end
    
    def code_params
      @code_params ||= params.
        permit(:name)
    end
  end
end
