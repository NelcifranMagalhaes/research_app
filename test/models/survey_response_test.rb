require 'test_helper'

class SurveyResponseTest < ActiveSupport::TestCase
  test 'should belong to employee' do
    assert_respond_to SurveyResponse.new, :employee
  end

  test 'should belong to organization' do
    assert_respond_to SurveyResponse.new, :organization
  end

  test 'should belong to question' do
    assert_respond_to SurveyResponse.new, :question
  end
end
