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

    def self.get_currencies
      account = ::Stripe::Account.retrieve
      account.currencies_supported
    end

    def create_plan
      begin
        ::Stripe::Plan.create(
            amount: stripe_amount(amount),
            interval: interval,
            interval_count: interval_count,
            name: name,
            currency: currency,
            id: api_plan_id,
            trial_period_days: trial_period_days)
      rescue ::Stripe::InvalidRequestError
        Rails.logger.info 'Stripe plan already exists!'
      end
    end

    def delete_plan
      stripe_plan = retrieve_api_plan
      stripe_plan.delete
    end

    def update_plan
      stripe_plan = retrieve_api_plan(api_plan_id)
      stripe_plan.name = name
      stripe_plan.save
    end

    def self.get_subscription_plans
      ::Stripe::Plan.all
    end

    def self.native_amount(amount)
      (amount / 100)
    end

    private

    def retrieve_api_plan(plan_id)
      ::Stripe::Plan.retrieve(plan_id)
    end

    def stripe_amount(amount)
      (amount * 100).to_i
    end
  end
end
