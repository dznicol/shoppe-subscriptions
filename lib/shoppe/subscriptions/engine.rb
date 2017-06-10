require 'shoppe/navigation_manager'
require 'shoppe/subscriptions/customer_extensions'

module Shoppe
  module Subscriptions
    class Engine < ::Rails::Engine
      isolate_namespace Shoppe::Subscriptions

      config.to_prepare do
        Shoppe::Customer.send :include do
          has_many :subscribers, class_name: 'Shoppe::Subscriber', inverse_of: 'customer'
        end
      end

      # Load default navigation
      config.after_initialize do
        require 'shoppe/subscriptions/subscription_navigation'
      end
    end
  end
end
