require 'fileutils'
require 'securerandom'

module V1
  class ResearchImportController < ApplicationController
    def import
      file = params[:file]

      return render json: { error: 'No file uploaded' }, status: :bad_request unless file.present?

      stored_path = persist_upload(file)
      job = CsvImportJob.perform_later(stored_path)

      render json: { message: 'Import queued', file: file.original_filename, job_id: job.job_id }, status: :accepted
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def reset_database
      ResetDatabaseJob.perform_later
      render json: { message: 'Database reset queued' }, status: :accepted
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def persist_upload(file)
      upload_dir = Rails.root.join('tmp', 'uploads')
      FileUtils.mkdir_p(upload_dir)

      stored_path = upload_dir.join("upload_#{SecureRandom.uuid}.csv")
      FileUtils.cp(file.path, stored_path)

      stored_path.to_s
    end
  end
end
