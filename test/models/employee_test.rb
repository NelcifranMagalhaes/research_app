require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  test 'should have many survey_responses' do
    assert_respond_to Employee.new, :survey_responses
  end
end
