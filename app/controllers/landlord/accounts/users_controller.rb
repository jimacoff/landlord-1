require_dependency "landlord/application_controller"

module Landlord
  class Accounts::UsersController < ApplicationController
    before_action :require_active_account
    before_action :require_account_owner
    before_action :set_membership, only: [:edit, :update, :destroy]

    # Display list of users (with invite form)
    # GET /1/users
    def index
      @roles = roles
    end

    # Invite user(s) to account
    # POST /1/users
    def create
      email_array = params[:email_addresses].split("\r\n")
      role_id = params[:role_id]

      if email_array.any? && roles.any? {|r| r[:id] == role_id}
        email_array.each do |email|
          invite_sent = false

          u = User.find_by(email: email)
          if !u
            u = User.invite!(email: email)
            invite_sent = true
          end

          m = u.memberships.find_by(account: current_account)
          if !m
            m = u.memberships.new(account: current_account, role: role_id)
            m.save

            if !invite_sent
              AccountMailer.invite(m).deliver_later
            end
          end

        end

        redirect_to account_users_path(current_account), notice: 'Users were invited to your account.'
      end
    end

    # Display edit form for a user
    # GET /1/users/1
    def edit
      if @membership.user_id == current_user.id
        redirect_to account_users_path(current_account), alert: 'Cannot edit yourself.'
      elsif @membership.owner?
        redirect_to account_users_path(current_account), alert: 'Cannot edit the account owner.'
      else
        @roles = roles
      end
    end

    # Update a user
    # PATCH/PUT /1/users/1
    def update
      role_id = params[:role_id]
      @membership.role = role_id
      if @membership.save
        redirect_to account_users_path(current_account), notice: 'User updated.'
      else
        render :edit
      end
    end

    # Remove a user from the account
    # DELETE /1/users/1
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
