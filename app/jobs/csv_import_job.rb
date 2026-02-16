class CsvImportJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    CsvProcessing.new(file_path).process
  ensure
    File.delete(file_path) if file_path.present? && File.exist?(file_path)
  end
end
