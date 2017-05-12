require 'stripe'

module Shoppe
  module ApiHandler
    extend ActiveSupport::Concern

    INTERVALS = [:day, :month, :week, :year]

    included do
      after_create :create_plan
      after_update :update_plan, if: :name_changed?
      before_destroy :delete_plan
    end

    def self.get_currencies(api_key=nil)
      # As of Stripe API version '2015-10-16' we need to get the account country then the country spec
      account = ::Stripe::Account.retrieve(api_key || @stripe_api_key || Shoppe::Stripe.api_key)
      country_spec = ::Stripe::CountrySpec.retrieve(account.country, api_key || @stripe_api_key || Shoppe::Stripe.api_key)
      country_spec.supported_payment_currencies
    end

    def create_plan(api_key = nil)
      begin
        ::Stripe::Plan.create({
                                  amount: stripe_amount(amount),
                                  interval: interval,
                                  interval_count: interval_count,
                                  name: name,
                                  currency: currency,
                                  id: api_plan_id,
                                  trial_period_days: trial_period_days
                              }, api_key || @stripe_api_key || Shoppe::Stripe.api_key)
      rescue ::Stripe::InvalidRequestError
        Rails.logger.info 'Stripe plan already exists!'
      end
    end

    def delete_plan(api_key=nil)
      stripe_plan = retrieve_api_plan(api_key || @stripe_api_key || Shoppe::Stripe.api_key)
      stripe_plan.delete
    end

    def update_plan(api_key=nil)
      stripe_plan = retrieve_api_plan(api_plan_id, api_key || @stripe_api_key || Shoppe::Stripe.api_key)
      stripe_plan.name = name
      stripe_plan.save
    end

    def self.get_subscription_plans(api_key=nil)
      ::Stripe::Plan.all({}, api_key || @stripe_api_key || Shoppe::Stripe.api_key)
    end

    def self.native_amount(amount)
      amount / 100.0
    end

    private

    def retrieve_api_plan(plan_id, api_key=nil)
      ::Stripe::Plan.retrieve(plan_id, api_key || @stripe_api_key || Shoppe::Stripe.api_key)
    end

    def stripe_amount(amount)
      (amount * 100).to_i
    end
  end
end
