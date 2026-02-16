require 'test_helper'

module Employees
  class CreateUseCaseTest < ActiveSupport::TestCase
    test 'should create employee with valid params' do
      params = {
        name: 'John Doe',
        personal_email: 'john@example.com',
        corporate_email: 'john@company.com',
        gender: 'Male',
        generation: 'Millennial',
        company_tenure: '5 years'
      }

      use_case = Employees::CreateUseCase.new(params)
      employee = use_case.execute

      assert_not_nil employee
      assert_equal 'John Doe', employee.name
      assert_equal 'john@example.com', employee.personal_email
      assert_empty use_case.errors
    end

test 'should create employee even with empty params' do
    params = {}

    use_case = Employees::CreateUseCase.new(params)
    employee = use_case.execute

    assert_not_nil employee
    assert_empty use_case.errors
    end

    test 'should persist employee to database' do
      params = {
        name: 'Jane Doe',
        personal_email: 'jane@example.com'
      }

      use_case = Employees::CreateUseCase.new(params)

      assert_difference 'Employee.count', 1 do
        use_case.execute
      end
    end
  end
end
