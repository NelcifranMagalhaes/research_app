require 'test_helper'

module V1
  class SurveyResponsesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @survey_response_one = survey_responses(:one)
      @survey_response_two = survey_responses(:two)
      @employee = employees(:one)
    end

    test 'should get index with survey responses' do
      get '/v1/survey_responses'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_includes json_response.keys, 'data'
      assert_equal 2, json_response['data'].length
    end

    test 'should return paginated results with links' do
      get '/v1/survey_responses'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_not_empty json_response['links']
    end

    test 'should return survey response data with correct attributes' do
      get '/v1/survey_responses'

      assert_response :success
      json_response = JSON.parse(response.body)
      survey_response_data = json_response['data'].first

      assert_not_nil survey_response_data['id']
      assert_not_nil survey_response_data['employee_id']
      assert_not_nil survey_response_data['organization_id']
      assert_not_nil survey_response_data['question_id']
    end

    test 'should return json format' do
      get '/v1/survey_responses'

      assert_response :success
      assert_match 'application/json', response.content_type
    end

    test 'should get survey responses by employee id' do
      get "/v1/survey_responses_by_employee?employee_id=#{@employee.id}"

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_includes json_response.keys, 'data'
      assert json_response['data'].all? { |sr| sr['employee_id'] == @employee.id }
    end

    test 'should return error when employee_id is missing' do
      get '/v1/survey_responses_by_employee'

      assert_response :bad_request
      json_response = JSON.parse(response.body)

      assert_equal 'employee_id is required', json_response['error']
    end

    test 'should return empty list for non-existent employee' do
      get '/v1/survey_responses_by_employee?employee_id=99999'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_empty json_response['data']
    end
  end
end
