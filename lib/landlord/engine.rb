require "stripe"

module Landlord
  class Engine < ::Rails::Engine
    isolate_namespace Landlord

    if Rails.env.development? 
      OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    end
  end
end
