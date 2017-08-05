require_dependency "landlord/application_controller"

module Landlord
  class Accounts::ReceiptsController < ApplicationController
    before_action :require_account_owner
    before_action :set_receipt, only: [:show]

    # Display list of receipts
    # GET /1/receipts
    def index
      @receipts = @current_account.receipts.all
    end

    # Display individual receipt
    # GET /1/receipts/1
    def show
    end

    private

      def set_receipt
        @receipt = @current_account.receipts.find(params[:id])
      end
  end
end
