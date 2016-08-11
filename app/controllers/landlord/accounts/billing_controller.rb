require_dependency "landlord/application_controller"

module Landlord
  class Accounts::BillingController < ApplicationController
    before_action :require_account
    before_action :require_account_owner

    # Display credit card entry form
    # GET /1/billing
    def edit
      authorize current_account
      @has_billing_info = current_account.card_last4 && current_account.card_exp_month && current_account.card_exp_year
    end

    # Save credit card details to Stripe and database
    # POST /1/billing
    def update
      customer = Stripe::Customer.retrieve(current_account.stripe_id)
      customer.source = params[:stripe_token]
      customer.save
      subscription = customer.subscriptions.first

      current_account.status = subscription.status
      current_account.card_name = params[:stripe_card_name]
      current_account.card_brand = params[:stripe_card_brand]
      current_account.card_last4 = params[:stripe_card_last4]
      current_account.card_exp_month = params[:stripe_card_exp_month]
      current_account.card_exp_year = params[:stripe_card_exp_year]

      current_account.save
      redirect_to account_billing_path(current_account), notice: 'Card was successfully updated.'
    end

  end
end
