module Api
  class ProposedLawsController < ApplicationController
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
    expose :working_file do
      path = params[:path_in_repo].is_a?(String) ? params[:path_in_repo] : ""
      proposed_law.working_file path
    end
    helper_method :proposed_laws
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

    def show_node
      respond_to do |format|
        format.json do
          if working_file.exists?
            render 'show_node', status: 200
          else
            render nothing: true, status: 404
          end
        end
      end
    end

    def create_node
      working_file.attributes = proposed_law_node_params
      respond_to do |format|
        format.json do
          if working_file.create
            render 'show_node', status: 201
          else
            render 'errors', status: 422
          end
        end
      end
    end

    def update_node
      working_file.attributes = proposed_law_node_params
      respond_to do |format|
        format.json do
          if working_file.update
            render nothing: true, status: 204
          else
            render 'errors', status: 422
          end
        end
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

    def proposed_law_node_params
      allowed_params = [ :content, { metadata: [ :number, :title,
        { structure: [ [ :name, :number, :title, :optional ] ] } ] } ]
      @proposed_law_node_params ||= params.
        permit(*allowed_params)
    end
  end
end
