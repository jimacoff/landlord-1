require_dependency "landlord/application_controller"

module Landlord
  class Accounts::SettingsController < ApplicationController
    before_action :require_active_account
    before_action :require_account_owner

    # Display account settings form
    # GET /1/settings/edit
    def edit
      @plans = Plan.all
      @users = current_account.users
      @owner_id = current_account.owner.id
      @billing_address = current_account.settings(:billing).address
      @billing_cc_emails = current_account.settings(:billing).cc_emails
    end

    # Update account settings
    # PATCH/PUT /1/settings
    def update
      if current_account.update_settings(account_params)
        if current_account.owner == current_user
          redirect_to edit_account_settings_path(current_account), notice: 'Account was successfully updated.'
        else
          redirect_to current_account, notice: 'Account was successfully updated. You are no longer the Account Owner.'
        end
      else
        @plans = Plan.all
        render :edit
      end
    end

    private

      def account_params
        params.require(:account).permit(:name, :plan_id, :owner_id, :billing_address, :billing_cc_emails)
      end

  end
end
