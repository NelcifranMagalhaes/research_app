module V1
  class SurveyResponsesController < ApplicationController
    def index
      @pagy, @survey_responses = pagy(SurveyResponse.all)
      render json: { links: @pagy.urls_hash, data: @survey_responses }
    end
  end
end
