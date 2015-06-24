module Api
  module ProposedLaws
    class WorkingFilesController < ApplicationController
      before_filter :decamelize_params!, :camelize_output!
      expose :proposed_law do
        ProposedLaw.find params[:id]
      end
      expose :working_file do
        proposed_law.working_file tree
      end

      protected
      
      # By default, the tree parameter is just the tree parameter or an empty string
      def tree
        params[:tree].is_a?(String) ? params[:tree] : ""
      end
    end
  end
end
