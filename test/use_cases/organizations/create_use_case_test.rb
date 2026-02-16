require 'test_helper'

module Organizations
  class CreateUseCaseTest < ActiveSupport::TestCase
    test 'should create organization with valid params' do
      params = {
        company_name: 'ACME Corp',
        company_role: 'Developer',
        localization: 'São Paulo',
        job_title: 'Senior Developer',
        board: 'Technology',
        department: 'Engineering',
        management: 'Development',
        area: 'Backend',
        administration: 'Tech Admin'
      }

      use_case = Organizations::CreateUseCase.new(params)
      organization = use_case.execute

      assert_not_nil organization
      assert_equal 'ACME Corp', organization.company_name
      assert_equal 'Developer', organization.company_role
      assert_empty use_case.errors
    end

test 'should create organization even with empty params' do
    params = {}

    use_case = Organizations::CreateUseCase.new(params)
    organization = use_case.execute

    assert_not_nil organization
    assert_empty use_case.errors
    end

    test 'should persist organization to database' do
      params = {
        company_name: 'Test Company',
        company_role: 'Manager'
      }

      use_case = Organizations::CreateUseCase.new(params)

      assert_difference 'Organization.count', 1 do
        use_case.execute
      end
    end
  end
end
