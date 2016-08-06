require_dependency "landlord/application_controller"

module Landlord
  class Accounts::BillingInfoController < ApplicationController
    before_action :require_account

    def show
      if !@current_account.billing_info
        @current_account.build_billing_info
      end
      @billing_info = @current_account.billing_info
    end

    def create
      @billing_info = @current_account.build_billing_info(billing_info_params)

      respond_to do |format|
        if @billing_info.save
          format.html { redirect_to account_billing_info_path(@current_account), alert: 'Billing info was successfully updated.' }
          format.json { render :show, status: :created, location: @account }
        else
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @current_account.billing_info.update(billing_info_params)
          format.html { redirect_to account_billing_info_path(@current_account), alert: 'Billing info was successfully updated.' }
          format.json { render :show, status: :created, location: @account }
        else
          format.html { render :edit }
          format.json { render json: @sample.errors, status: :unprocessable_entity }
        end
      end
    end

    private

      def set_billing_info
        @billing_info = @current_account.billing_info
      end

      def billing_info_params
        params.require(:billing_info).permit(:address, :cc_emails)
      end
  end
end
