require_dependency "landlord/application_controller"

module Landlord
  class Accounts::ReceiptsController < ApplicationController
    before_action :require_account
    before_action :set_receipt, only: [:show]

    def index
      @receipts = @current_account.receipts.all
    end

    def show
    end

    private

      def set_receipt
        @receipt = @current_account.receipts.find(params[:id])
      end
  end
end
