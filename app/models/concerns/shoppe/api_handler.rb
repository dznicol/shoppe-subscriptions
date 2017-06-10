require 'stripe'

module Shoppe
  module ApiHandler
    extend ActiveSupport::Concern

    INTERVALS = [:day, :month, :week, :year]

    included do
      after_create :create_stripe_entity
      after_update :update_stripe_entity
      before_destroy :delete_stripe_entity
    end

    def self.get_currencies(api_key = nil)
      # As of Stripe API version '2015-10-16' we need to get the account country then the country spec
      account = ::Stripe::Account.retrieve(key(api_key))
      country_spec = ::Stripe::CountrySpec.retrieve(account.country, key(api_key))
      country_spec.supported_payment_currencies
    end

    def self.get_subscription_plans(api_key = nil)
      ::Stripe::Plan.all({}, key(api_key))
    end

    def self.native_amount(amount)
      amount / 100.0
    end

    def self.key(api_key)
      api_key || @stripe_api_key || Shoppe::Stripe.api_key
    end

    private

    def retrieve_api_plan(plan_id, api_key = nil)
      ::Stripe::Plan.retrieve(plan_id, key(api_key))
    end

    def retrieve_subscription(stripe_id, api_key = nil)
      ::Stripe::Subscription.retrieve(stripe_id, key(api_key))
    end

    def stripe_amount(amount)
      (amount * 100).to_i
    end
  end
end
