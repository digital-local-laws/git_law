module Api
  class JurisdictionsController < ApiController
    before_filter :decamelize_params!
    expose :jurisdiction
    expose( :unpaginated_jurisdictions ) { Jurisdiction.order(:name) }
    helper_method :jurisdictions

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
      jurisdiction.attributes = jurisdiction_params
      respond_to do |format|
        format.json do
          if jurisdiction.save
            render 'show', status: 201
          else
            render 'errors', status: 422
          end
        end
      end
    end

    def update
      jurisdiction.attributes = jurisdiction_params
      respond_to do |format|
        format.json do
          if jurisdiction.save
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
          if jurisdiction.destroy
            render nothing: true, status: 204
          else
            render nothing: true, status: 500
          end
        end
      end
    end

    private

    def jurisdictions
      @jurisdictions ||= paginate unpaginated_jurisdictions
    end

    def jurisdiction_params
      @jurisdiction_params ||= params.
        permit(:name)
    end
  end
end
