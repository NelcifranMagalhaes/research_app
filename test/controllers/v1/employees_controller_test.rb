require 'test_helper'

module V1
  class EmployeesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @employee_one = employees(:one)
      @employee_two = employees(:two)
    end

    test 'should get index with employees' do
      get '/v1/employees'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_includes json_response.keys, 'data'
      assert_equal 2, json_response['data'].length
    end

    test 'should return paginated results with links' do
      get '/v1/employees'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_not_empty json_response['links']
    end

    test 'should return employee data with correct attributes' do
      get '/v1/employees'

      assert_response :success
      json_response = JSON.parse(response.body)
      employee_data = json_response['data'].first

      assert_not_nil employee_data['id']
      assert_not_nil employee_data['name']
      assert_not_nil employee_data['personal_email']
      assert_not_nil employee_data['corporate_email']
    end

    test 'should return json format' do
      get '/v1/employees'

      assert_response :success
      assert_match 'application/json', response.content_type
    end
  end
end
