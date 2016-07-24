require_dependency "landlord/application_controller"

module Landlord
  class Accounts::SettingsController < ApplicationController
    before_action :require_active_account
    before_action :require_owner

    def index
      @plans = Plan.all
    end

    def update
      respond_to do |format|
        if @current_account.update(account_params)
          format.html { redirect_to account_settings_path(@current_account), alert: 'Account was successfully updated.' }
          format.json { render :show, status: :created, location: @account }
        else
          @plans = Plan.all
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    private

      def account_params
        params.require(:account).permit(:name, :plan_id)
      end
  end
end
