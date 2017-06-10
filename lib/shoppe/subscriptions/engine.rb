require 'shoppe/navigation_manager'

module Shoppe
  module Subscriptions
    class Engine < ::Rails::Engine
      isolate_namespace Shoppe::Subscriptions

      # Load default navigation
      config.after_initialize do
        require 'shoppe/subscriptions/subscription_navigation'
        require 'shoppe/subscriptions/customer_extensions'
      end
    end
  end
end
