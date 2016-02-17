class ApiController < ApplicationController
  rescue_from 'ActiveRecord::RecordNotFound', with: :not_found

  # Alert client that record was not found
  def not_found
    respond_to do |format|
      format.json do
        render nothing: true, status: 404
      end
    end
  end
end
