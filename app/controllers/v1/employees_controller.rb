module V1
  class EmployeesController < ApplicationController
    def index
      @pagy, @employees = pagy(Employee.all)
      render json: { links: @pagy.urls_hash, data: @employees }
    end
  end
end
