require "stripe"

module Landlord
  class Engine < ::Rails::Engine
    isolate_namespace Landlord
  end
end
