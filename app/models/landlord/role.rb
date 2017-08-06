module Landlord
  class Role < ApplicationRecord
    self.table_name = 'roles'

    has_many :memberships

    validates :key, presence: true, uniqueness: { case_sensitive: false }
    validates :name, presence: true

    scope :not_owner, -> { where.not(key: 'owner') }

    def self.keys
      select(:key).map(&:key)
    end

    # Landlord::Role.owner, Landlord::Role.admin, etc
    Landlord::Role.keys.each do |key|
      define_singleton_method("#{key}") { find_by_key(key) }
    end

  end
end
