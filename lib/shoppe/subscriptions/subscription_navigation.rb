require 'shoppe/navigation_manager'

Shoppe::NavigationManager.find(:admin_primary).add_item(:subscription_plans)
Shoppe::NavigationManager.find(:admin_primary).add_item(:subscriptions)
