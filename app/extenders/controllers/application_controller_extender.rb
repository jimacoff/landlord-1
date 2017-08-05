::ApplicationController.class_eval do
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_account, :current_membership, :require_account, :require_active_account

  def current_account
    @current_account
  end

  def current_membership
    @current_membership
  end

  def require_account
    get_current_account_and_membership
    redirect_to(accounts_path) unless @current_account
  end

  def require_active_account
    get_current_account_and_membership
    if !@current_account
      redirect_to accounts_path # User does not belong to the requested account
    else
      if @current_account.status == 'past_due' || @current_account.status == 'unpaid'
        if @current_membership.owner?
          redirect_to account_billing_path(@current_account), alert: "Your account is past due. Please enter payment details to reactivate."
        else
          redirect_to account_past_due_path(@current_account), alert: "This account is past due. Please contact your account owner (#{@current_account.owner.first_name} #{@current_account.owner.last_name})."
        end
      end
    end
  end

  def require_account_owner
    if !@current_membership.owner?
      redirect_to account_path(@current_account)
    end
  end

  private

    def get_current_account_and_membership
      if !@current_account
        authenticate_user!
        account_id = params[:account_id]
        if current_user && account_id
          @current_account = current_user.accounts.not_canceled.find_by(id: account_id)
        end
        if @current_account
          @current_membership = Landlord::Membership.find_by(user: current_user, account: @current_account)
        end
      end
    end

    def user_not_authorized
      flash[:notice] = "You are not authorized to perform this action."
      if (current_account)
        redirect_to(request.referrer || account_path(current_account))
      else
        redirect_to(request.referrer || root_path)
      end
    end

end
