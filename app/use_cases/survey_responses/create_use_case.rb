module SurveyResponses
  class CreateUseCase
    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def execute
      survey_response = SurveyResponse.new(@params)

      if survey_response.save
        survey_response
      else
        @errors = survey_response.errors.full_messages
        nil
      end
    end
  end
end
