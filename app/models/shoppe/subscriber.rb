module Shoppe
  class Subscriber < ActiveRecord::Base
    include ApiHandler

    belongs_to :subscription_plan, class_name: 'Shoppe::SubscriptionPlan'

    belongs_to :customer, class_name: 'Shoppe::Customer'

    has_many :transactions, class_name: 'Shoppe::SubscriberTransaction'

    has_many :gifts, class_name: 'Shoppe::Gift', inverse_of: :subscriber

    default_scope { where(cancelled_at: nil) }

    private

    def create_stripe_entity(_api_key = nil)
      Rails.logger.warn 'Creation of Subscribers from Shoppe interface is not currently supported'
    end

    def delete_stripe_entity(api_key = nil)
      subscription = retrieve_subscription(stripe_id, api_key)
      subscription.delete
    end

    def update_stripe_entity(_api_key = nil)
      # Nothing to update?
    end
  end
end
