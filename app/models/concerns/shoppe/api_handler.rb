module Shoppe
  module ApiHandler
    extend ActiveSupport::Concern

    included do
      before_validation :set_api_plan_id, on: :create
      after_create :create_plan
      after_update :update_plan, if: [:name_changed?, :amount_changed?, :interval_changed?, :interval_count_changed?]
      before_destroy :delete_plan
    end

    def create_plan
      Stripe::Plan.create(
          amount: stripe_amount(plan.amount),
          interval: plan.interval,
          interval_count: plan.interval_count,
          name: plan.name,
          currency: plan.currency,
          id: plan.api_plan_id,
          trial_period_days: plan.trial_period_days)
    end

    def delete_plan
      stripe_plan = retrieve_api_plan(plan)
      stripe_plan.delete
    end

    def update_plan
      stripe_plan = retrieve_api_plan(plan)
      stripe_plan.name = plan.name
      stripe_plan.save
    end

    def set_api_plan_id(plan)
      plan.api_plan_id = "Shoppe-Plan-#{Time.current.to_i}"
    end

    private

    def retrieve_api_plan(plan)
      Stripe::Plan.retrieve(plan.api_plan_id)
    end

    def stripe_amount(amount)
      (amount * 100).to_i
    end
  end
end
