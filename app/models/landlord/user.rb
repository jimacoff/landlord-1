module Landlord
  class User < ApplicationRecord
    self.table_name = 'users'

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :invitable, :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]

    has_many :memberships
    has_many :accounts, through: :memberships

    def name
      out_name = "#{first_name} #{last_name}".strip
      out_name = email if out_name.empty?
    end

    def self.init_from_google_oauth2(auth_data)
      if auth_data && auth_data.info && auth_data.provider && auth_data.uid
        info = auth_data.info
        provider = auth_data.provider
        uid = auth_data.uid

        # Find user or initialize a new one
        user = User.where(email: info['email']).first
        unless user
          user = User.new(
            first_name: info['first_name'],
            last_name: info['last_name'],
            email: info['email'],
            password: Devise.friendly_token[0,20],
            provider: provider,
            uid: uid
          )
          user.skip_confirmation!
        end

        user
      else
        nil
      end
    end

    def self.find_for_google_oauth2(auth_data, signed_in_resource=nil)
      info = auth_data.info
      user = User.where(email: info['email']).first
    end

  end
end
