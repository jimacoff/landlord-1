module Landlord
  module AccountsHelper

    # Helpers for Devise forms

    def resource
      @resource ||= User.new
    end

    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
    end
  end
end
