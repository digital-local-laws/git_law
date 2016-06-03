module ProposedLaws
  class WorkingFilesController < ApplicationController
    expose :proposed_law do
      ProposedLaw.find params[:id]
    end
    expose :working_file do
      proposed_law.working_file tree
    end

    helper_method :proposed_law, :working_file

    protected

    # By default, the tree parameter is just the tree parameter or an empty string
    def tree
      params[:tree].is_a?(String) ? params[:tree] : ""
    end
  end
end
