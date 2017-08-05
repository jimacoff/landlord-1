require_dependency "landlord/application_controller"

module Landlord
  class Accounts::BillingController < ApplicationController
    before_action :require_account_owner

    # Display credit card entry form
    # GET /1/billing/edit
    def edit
      authorize(current_account)
      @has_billing_info = current_account.card_last4 && current_account.card_exp_month && current_account.card_exp_year
      @users = current_account.users
      @owner_id = current_account.owner.id
    end

    # Save credit card details to Stripe and database
    # PATCH/PUT /1/billing
    def update
      if current_account.update_stripe_card(billing_params)
        redirect_to edit_account_billing_path(current_account), notice: 'Card was successfully updated.'
      else
        render :edit
      end
    end

    private

      def billing_params
        params.require(:stripe).permit(:token, :card_name, :card_brand, :card_last4, :card_exp_month, :card_exp_year)
      end

  end
end
