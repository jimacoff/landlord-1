require_dependency "landlord/application_controller"

module Landlord
  class AccountsController < ApplicationController

    def new
      @account = Account.new
      @account.memberships.build.build_user
      @current_user = current_user
    end

    def create
      @account = Account.new(account_params)

      respond_to do |format|
        if @account.save
          format.html { redirect_to @account, notice: 'Account was successfully created.' }
          format.json { render :show, status: :created, location: @account }
        else
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
        params.require(:account).permit(:name, memberships_attributes: [ user_attributes: [ :first_name, :last_name, :email, :password ] ])
      end

  end
end
