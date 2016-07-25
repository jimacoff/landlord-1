require_dependency "landlord/application_controller"

module Landlord
  class Accounts::UsersController < ApplicationController
    before_action :require_active_account
    before_action :require_owner

    def index
    end

    def create
      email_array = user_params.split("\r\n")
      email_array.each do |email|
        u = User.invite!(email: email)
        m = u.memberships.new(account: @current_account, is_owner: false)
        m.save
      end
    end

    private

      def user_params
        params.require(:email_addresses)
      end
  end
end
