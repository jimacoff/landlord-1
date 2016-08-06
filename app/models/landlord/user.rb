module Landlord
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :invitable, :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]

    has_many :memberships
    has_many :accounts, through: :memberships

    def name
      out_name = "#{first_name} #{last_name}".strip
      if out_name.empty?
        out_name = email
      end
      out_name
    end

    def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(:email => data["email"]).first
      user
    end
  end
end
