module ProposedLaws
  # For direct interaction with files and their contents
  class FilesController < WorkingFilesController
    expose :working_files do
      working_file.children
    end
    expose :content do
      params[:content]
    end

    helper_method :working_files, :content

    def index
      if working_file.exists?
        render status: 200
      else
        render nothing: true, status: 404
      end
    end

    def show
      if working_file.exists?
        render 'show', status: 200
      else
        render nothing: true, status: 404
      end
    end

    def create
      working_file.content = content
      if working_file.create
        render 'show', status: 201
      else
        render 'errors', status: 422
      end
    end

    def update
      working_file.content = content
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
