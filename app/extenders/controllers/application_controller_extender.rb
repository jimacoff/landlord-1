::ApplicationController.class_eval do
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_account, :current_membership, :require_account, :require_active_account

  # Return the current account
  def current_account
    @current_account
  end

  # Return the current user-account membership
  def current_membership
    @current_membership
  end

  # Require a current account and user membership
  def require_account
    get_current_account_and_membership
    return user_not_authorized unless @current_account
  end

  # Require a current active account and user membership
  def require_active_account
    get_current_account_and_membership
    return user_not_authorized unless @current_account

    if @current_account.billing_error?
      if @current_membership.owner?
        redirect_to account_billing_path(@current_account), alert: 'Your account is past due. Please enter payment details to reactivate.'
      else
        redirect_to account_past_due_path(@current_account), alert: "This account is past due. Please contact your account owner (#{@current_account.owner.first_name} #{@current_account.owner.last_name})."
      end
    end
  end

  # Require a current account, and require that the current user owns it
  def require_account_owner
    get_current_account_and_membership
    return user_not_authorized unless @current_account

    if @current_membership && !@current_membership.owner?
      redirect_to account_path(@current_account)
    end
  end

  private

    # Get the current account and user membership
    def get_current_account_and_membership
      if !@current_membership || !@current_account
        account_id = params[:account_id]
        authenticate_user! unless current_user
        @current_membership = Landlord::Membership.find_by(user_id: current_user.id, account_id: account_id) if account_id
        @current_account = @current_membership.account if @current_membership
      end
    end

    # Redirect unauthorized users
    def user_not_authorized
      flash[:notice] = 'You are not authorized to perform this action.'

      if @current_account
        redirect_to(request.referrer || account_path(current_account))
      else
        redirect_to(request.referrer || current_user ? authenticated_root_path : unauthenticated_root_path)
      end
    end

end
