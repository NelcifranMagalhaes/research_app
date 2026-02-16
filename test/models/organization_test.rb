require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test 'should have many survey_responses' do
    assert_respond_to Organization.new, :survey_responses
  end
end
