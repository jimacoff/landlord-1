require_dependency "landlord/application_controller"

module Landlord
  class Accounts::SettingsController < ApplicationController
    before_action :require_active_account

    def index
    end
  end
end
