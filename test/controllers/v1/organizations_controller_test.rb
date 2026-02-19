require 'test_helper'

module V1
  class OrganizationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @organization_one = organizations(:one)
      @organization_two = organizations(:two)
    end

    test 'should get index with organizations' do
      get '/v1/organizations'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_includes json_response.keys, 'data'
      assert_equal 2, json_response['data'].length
    end

    test 'should return paginated results with links' do
      get '/v1/organizations'

      assert_response :success
      json_response = JSON.parse(response.body)

      assert_includes json_response.keys, 'links'
      assert_not_empty json_response['links']
    end

    test 'should return organization data with correct attributes' do
      get '/v1/organizations'

      assert_response :success
      json_response = JSON.parse(response.body)
      organization_data = json_response['data'].first

      assert_not_nil organization_data['id']
      assert_not_nil organization_data['company_name']
      assert_not_nil organization_data['company_role']
    end

    test 'should return json format' do
      get '/v1/organizations'

      assert_response :success
      assert_match 'application/json', response.content_type
    end
  end
end
