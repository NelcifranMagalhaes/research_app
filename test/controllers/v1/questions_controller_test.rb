require 'test_helper'

module V1
  class QuestionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @question_one = questions(:one)
      @question_two = questions(:two)
    end

    test 'should get index with questions' do
      get '/v1/questions'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_includes json_response.keys, 'data'
      assert_equal 2, json_response['data'].length
    end

    test 'should return paginated results with links' do
      get '/v1/questions'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_not_empty json_response['links']
    end

    test 'should return question data with correct attributes' do
      get '/v1/questions'

      assert_response :success
      json_response = JSON.parse(response.body)
      question_data = json_response['data'].first

      assert_not_nil question_data['id']
      assert_not_nil question_data['theme']
    end

    test 'should return json format' do
      get '/v1/questions'

      assert_response :success
      assert_match 'application/json', response.content_type
    end
  end
end
