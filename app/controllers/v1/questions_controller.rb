module V1
  class QuestionsController < ApplicationController
    def index
      @pagy, @questions = pagy(Question.all)
      render json: { links: @pagy.urls_hash, data: @questions }
    end
  end
end
