module Shoppe::Subscriptions
  class Subscriber < ActiveRecord::Base
    belongs_to :subscription_plan, class_name: 'Shoppe::SubscriptionPlan'
    belongs_to :customer, class_name: 'Shoppe::Customer'
  end
end
