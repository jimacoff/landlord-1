require_dependency "landlord/application_controller"

module Landlord
  class Accounts::MembershipsController < ApplicationController
    before_action :require_active_account
    before_action :require_account_owner
    before_action :set_roles
    before_action :set_membership, only: [:edit, :update, :destroy]

    # Display list of user memberships (with invite form)
    # GET /1/users
    def index
      @memberships = @current_account.memberships.all
    end

    # Invite user(s) to account
    # POST /1/users
    def create
      email_array = params[:email_addresses].split("\r\n")
      role_id = params[:role_id]

      if email_array.any? && @roles.any? {|r| r[:id] == role_id}
        email_array.each do |email|
          invite_sent = false

          u = User.find_by(email: email)
          if !u
            u = User.invite!(email: email)
            invite_sent = true
          end

          m = u.memberships.find_by(account: @current_account)
          if !m
            m = u.memberships.new(account: @current_account, role: role_id)
            m.save

            if !invite_sent
              AccountMailer.invite(m).deliver_later
            end
          end

        end

        redirect_to account_memberships_path(@current_account), notice: 'Users were invited to your account.'
      end
    end

    # Display edit form for a user membership
    # GET /1/users/1
    def edit
    end

    # Update a user membership
    # PATCH/PUT /1/users/1
    def update
      if @membership.update(membership_params)
        redirect_to account_memberships_path(@current_account), notice: 'User updated.'
      else
        render :edit
      end
    end

    # Remove a user from the account
    # DELETE /1/users/1
    def destroy
      @membership.destroy
      redirect_to account_memberships_path(@current_account), notice: 'User removed.'
    end

    private

      def set_roles
        @roles = [
          { name: 'Normal', id: 'normal'},
          { name: 'Admin', id: 'admin'},
          { name: 'Read-only', id: 'restricted'}
        ]
      end

      def set_membership
        @membership = @current_account.memberships.find_by(user_id: params[:id])

        if @membership.user_id == current_user.id
          redirect_to account_memberships_path(@current_account), alert: 'Cannot edit yourself.'
        elsif @membership.owner?
          redirect_to account_memberships_path(@current_account), alert: 'Cannot edit the account owner.'
        end
      end

      def membership_params
        params.require(:membership).permit(:role)
      end
  end
end
