require_dependency "landlord/application_controller"

module Landlord
  class Accounts::UsersController < ApplicationController
    before_action :require_active_account
    before_action :require_account_owner

    def index
      @roles = roles
    end

    def create
      email_array = params[:email_addresses].split("\r\n")
      role_id = params[:role_id]

      if email_array.any? && roles.any? {|r| r[:id] == role_id}
        email_array.each do |email|
          u = User.invite!(email: email)
          m = u.memberships.new(account: current_account, role: role_id)
          m.save
        end

        redirect_to account_users_path(current_account), notice: 'Users were invited to your account.'
      end
    end

    private

      def roles
        [
          { name: 'Normal', id: 'normal'},
          { name: 'Admin', id: 'admin'},
          { name: 'Read-only', id: 'restricted'}
        ]
      end

  end
end
