module Shoppe
  class Subscriber < ActiveRecord::Base
    belongs_to :subscription_plan, class_name: 'Shoppe::SubscriptionPlan'
    belongs_to :customer, class_name: 'Shoppe::Customer'
    has_many :subscriber_transactions, class_name: 'Shoppe::SubscriberTransaction'
  end
end
