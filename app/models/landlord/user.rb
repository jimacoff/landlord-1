module Landlord
  class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :invitable, :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :confirmable

    has_many :memberships
    has_many :accounts, through: :memberships

    def name
      out_name = "#{first_name} #{last_name}".strip
      if out_name.empty?
        out_name = email
      end
      out_name
    end
  end
end
