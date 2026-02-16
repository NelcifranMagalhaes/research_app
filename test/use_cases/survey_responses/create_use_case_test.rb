require 'test_helper'

module SurveyResponses
  class CreateUseCaseTest < ActiveSupport::TestCase
    test 'should create survey response with valid params' do
      employee = employees(:one)
      organization = organizations(:one)
      question = questions(:one)

      params = {
        employee_id: employee.id,
        organization_id: organization.id,
        question_id: question.id,
        answer_date: '2026-02-15',
        score: 5,
        comment: 'Great experience'
      }

      use_case = SurveyResponses::CreateUseCase.new(params)
      survey_response = use_case.execute

      assert_not_nil survey_response
      assert_equal employee.id, survey_response.employee_id
      assert_equal 5, survey_response.score
      assert_empty use_case.errors
    end

    test 'should return nil and set errors when params are invalid' do
      params = {
        score: 10
      }

      use_case = SurveyResponses::CreateUseCase.new(params)
      survey_response = use_case.execute

      assert_nil survey_response
      assert_not_empty use_case.errors
    end

    test 'should persist survey response to database' do
      employee = employees(:one)
      organization = organizations(:one)
      question = questions(:one)

      params = {
        employee_id: employee.id,
        organization_id: organization.id,
        question_id: question.id,
        answer_date: '2026-02-15',
        score: 3
      }

      use_case = SurveyResponses::CreateUseCase.new(params)

      assert_difference 'SurveyResponse.count', 1 do
        use_case.execute
      end
    end
  end
end
