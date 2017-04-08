module Shoppe
  class SubscriptionPlan < ActiveRecord::Base
    include ApiHandler

    self.table_name = 'shoppe_subscription_plans'

    # Validations
    validates :name, presence: true
    validates :amount, presence: true
    validates :interval, presence: true

    belongs_to :product, class_name: 'Shoppe::Product'

    has_many :subscribers, class_name: 'Shoppe::Subscriber'

    attr_accessor :stripe_api_key

    def cancelled_subscribers
      subscribers.unscoped.where(subscription_plan_id: id).where.not(cancelled_at: nil)
    end
  end
end
