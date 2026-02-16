module Questions
  class CreateUseCase
    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def execute
      question = Question.new(@params)

      if question.save
        question
      else
        @errors = question.errors.full_messages
        nil
      end
    end
  end
end
