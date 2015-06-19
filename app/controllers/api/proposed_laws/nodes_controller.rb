module Api
  module ProposedLaws
    # For interaction with nodes
    class NodesController < WorkingFilesController
      expose :node do
        working_file.node
      end
      expose :nodes do
        node.child_nodes
      end
      expose :attributes do
        params[:attributes]
      end

      # TODO add before filter that issues error when file name is not a
      # valid node

      def index
        respond_to do |format|
          format.json do
            if node.exists?
              render 'index', status: 200
            else
              render nothing: true, status: 404
            end
          end
        end
      end

      def show
        respond_to do |format|
          format.json do
            if node.exists?
              render 'show', status: 200
            else
              render nothing: true, status: 404
            end
          end
        end
      end

      def create
        logger.info "Attributes: #{attributes}"
        node.attributes = attributes
        logger.info "Node: #{node.attributes}"
        respond_to do |format|
          format.json do
            if node.create
              render nothing: true, status: 201
            else
              render 'errors', status: 422
            end
          end
        end
      end

      def update
        node.attributes = attributes
        respond_to do |format|
          format.json do
            if !node.exists?
              render nothing: true, status: 404
            elsif node.update
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
            node.destroy
            render nothing: true, status: 204
          end
        end
      end
    end
  end
end
