require_dependency "landlord/application_controller"

module Landlord
  class Accounts::UsersController < ApplicationController
    before_action :require_active_account
    before_action :require_account_owner
    before_action :set_membership, only: [:edit, :update, :destroy]

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

    def edit
      if @membership.user_id == current_user.id
        redirect_to account_users_path(current_account), alert: 'Cannot edit yourself.'
      elsif @membership.owner?
        redirect_to account_users_path(current_account), alert: 'Cannot edit the account owner.'
      else
        @roles = roles
      end
    end

    def update
      role_id = params[:role_id]
      @membership.role = role_id
      if @membership.save
        redirect_to account_users_path(current_account), notice: 'User updated.'
      else
        render :edit
      end
    end

    def destroy
      if @membership.user_id == current_user.id
        redirect_to account_users_path(current_account), alert: 'Cannot remove yourself from the account.'
      elsif @membership.owner?
        redirect_to account_users_path(current_account), alert: 'Cannot remove the account owner.'
      else
        @membership.destroy
        redirect_to account_users_path(current_account), notice: 'User removed.'
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

      def set_membership
        @membership = current_account.memberships.find_by(user_id: params[:id])
      end

  end
end
