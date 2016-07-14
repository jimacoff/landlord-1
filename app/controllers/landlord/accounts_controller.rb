require_dependency "landlord/application_controller"

module Landlord
  class AccountsController < ApplicationController
    before_action :authenticate_user!, only: [:index, :show]

    # List the logged-in user's accounts
    def index
      @accounts = current_user.accounts.not_canceled
      if @accounts.size == 1
        redirect_to account_path @accounts.first
      end
    end

    def new
      @account = Account.new
      @account.memberships.build.build_user
      @plans = Plan.all
      @current_user = current_user
    end

    def create
      @account = Account.new(account_params)

      respond_to do |format|
        if @account.save
          format.html { redirect_to @account, notice: 'Account was successfully created.' }
          format.json { render :show, status: :created, location: @account }
        else
          @plans = Plan.all
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end

    def show
      @account = Account.find_by(id: params[:id])
    end

    private

      def account_params
        params.require(:account).permit(:name, :plan_id, memberships_attributes: [ user_attributes: [ :first_name, :last_name, :email, :password ] ])
      end

  end
end
