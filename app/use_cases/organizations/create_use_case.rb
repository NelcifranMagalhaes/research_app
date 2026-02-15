module Organizations
  class CreateUseCase
    attr_reader :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def execute
      organization = Organization.new(@params)

      if organization.save
        organization
      else
        @errors = organization.errors.full_messages
        nil
      end
    end

    def success?
      @errors.empty?
    end
  end
end
