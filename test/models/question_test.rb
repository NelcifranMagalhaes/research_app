require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test 'should have many survey_responses' do
    assert_respond_to Question.new, :survey_responses
  end
end
