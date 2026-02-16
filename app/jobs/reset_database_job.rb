class ResetDatabaseJob < ApplicationJob
  queue_as :default

  def perform
    SurveyResponse.delete_all
    Question.delete_all
    Employee.delete_all
    Organization.delete_all
  end
end
