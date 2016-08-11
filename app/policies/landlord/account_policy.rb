module Landlord
  class AccountPolicy
    attr_reader :user, :account

    def initialize(user, account)
      @user = user
      @account = account
      @membership = account.memberships.find_by_user_id(user.id)
    end

    def edit?
      @membership.owner?
    end
  end
end
