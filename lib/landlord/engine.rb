require "stripe"

module Landlord
  class Engine < ::Rails::Engine
    isolate_namespace Landlord

    config.to_prepare do
      root = Landlord::Engine.root
      extenders_path = root + "app/extenders/**/*.rb"
      Dir.glob(extenders_path) do |file|
        Rails.configuration.cache_classes ? require(file) : load(file)
      end
    end

    if Rails.env.development?
      #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    end
  end
end
