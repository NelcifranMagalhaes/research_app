module V1
  class SurveyResponsesController < ApplicationController
    def index
      @pagy, @survey_responses = pagy(SurveyResponse.all)
      render json: { links: @pagy.urls_hash, data: @survey_responses }
    end

    def get_survey_responses_by_employee
      employee_id = params[:employee_id]
      unless employee_id.present?
        render json: { error: 'employee_id is required' }, status: :bad_request
        return
      end

      @pagy, @survey_responses = pagy(SurveyResponse.where(employee_id: employee_id))
      render json: { links: @pagy.urls_hash, data: @survey_responses }
    end
  end
end
