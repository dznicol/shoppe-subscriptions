module Shoppe
  class SubscriptionPlansController < ApplicationController

    before_filter { @active_nav = :subscription_plans }
    before_filter { params[:id] && @subscription_plan = Shoppe::SubscriptionPlan.find(params[:id]) }

    def index
      # @subscription_plans = Shoppe::SubscriptionPlan.all
      @subscription_plans = []
    end

    def new

    end
  end
end
