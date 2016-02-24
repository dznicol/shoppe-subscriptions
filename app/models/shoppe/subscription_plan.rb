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
  end
end
