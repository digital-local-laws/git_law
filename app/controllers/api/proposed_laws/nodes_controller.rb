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
      expose :recurse do
        params[:tree] == 'proposed-law.json'
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
        node.attributes = attributes
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

      # Move the node, then update the moved node
      def move_and_update_node
        newNode = node.move params[:to_tree]
        if newNode
          self.node = newNode
          update_node
        else
          false
        end
      end

      # Update the node in place
      def update_node
        node.attributes = attributes
        node.update
      end

      def update
        respond_to do |format|
          format.json do
            if !node.exists?
              render nothing: true, status: 404
            elsif ( params[:to_tree] ? move_and_update_node : update_node )
              render 'show', status: 200
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
