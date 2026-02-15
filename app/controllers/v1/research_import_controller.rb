module V1
  class ResearchImportController < ApplicationController
    def import
      file = params[:file]

      return render json: { error: 'No file uploaded' }, status: :bad_request unless file.present?

      CsvProcessing.new(file.path).process
      render json: { message: 'File imported successfully', file: file.original_filename }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
