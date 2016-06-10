require 'shoppe/navigation_manager'
require 'shoppe/subscriptions/customer_extensions'

module Shoppe
  module Subscriptions
    class Engine < ::Rails::Engine
      isolate_namespace Shoppe::Subscriptions

      config.to_prepare do
        Shoppe::Customer.send :include do
          has_one :subscriber, class_name: 'Shoppe::Subscriber'
        end
      end

      # Load default navigation
      config.after_initialize do
        require 'shoppe/subscriptions/subscription_navigation'
      end
    end
  end
end
