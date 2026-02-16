module Employees
  class CreateUseCase
    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def execute
      employee = Employee.new(@params)

      if employee.save
        employee
      else
        @errors = employee.errors.full_messages
        nil
      end
    end
  end
end
