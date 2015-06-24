module Api
  module ProposedLaws
    # For direct interaction with files and their contents
    class FilesController < WorkingFilesController
      expose :working_files do
        working_file.children
      end
      expose :content do
        params[:content]
      end

      def index
        respond_to do |format|
          format.json do
            if working_file.exists?
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
            if working_file.exists?
              render 'show', status: 200
            else
              render nothing: true, status: 404
            end
          end
        end
      end

      def create
        working_file.content = content
        respond_to do |format|
          format.json do
            if working_file.create
              render 'show', status: 201
            else
              render 'errors', status: 422
            end
          end
        end
      end

      def update
        working_file.content = content
        respond_to do |format|
          format.json do
            if !working_file.exists?
              render nothing: true, status: 404
            elsif working_file.update
              render nothing: true, status: 204
            else
              render 'errors', status: 422
            end
          end
        end
      end
    end
  end
end
