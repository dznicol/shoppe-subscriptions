require 'shoppe/navigation_manager'

module Shoppe
  module Subscriptions
    class Engine < Rails::Engine

      # Load default navigation
      config.after_initialize do
        require 'shoppe/subscriptions/subscription_navigation'
      end
    end
  end
end
