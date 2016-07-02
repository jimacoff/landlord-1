require_dependency "landlord/application_controller"

module Landlord
  class DashboardController < ApplicationController
    def index
      @account = Account.find_by(id: params[:account_id])
    end
  end
end
