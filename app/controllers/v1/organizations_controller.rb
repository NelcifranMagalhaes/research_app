module V1
  class OrganizationsController < ApplicationController
    def index
      @pagy, @organizations = pagy(Organization.all)
      render json: { links: @pagy.urls_hash, data: @organizations }
    end
  end
end
