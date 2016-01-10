module Shoppe
  module ShoppeSubscriptions
    class ApplicationController < ActionController::Base
      before_filter { @active_nav = :subscription_plans }
      before_filter { params[:id] && @subscription_plan = Shoppe::SubscriptionPlan.find(params[:id]) }

      def index
        # @subscription_plans = Shoppe::SubscriptionPlan.all
        @subscription_plans = []
      end

      def new
        @subscription_plan = Shoppe::SubscriptionPlan.new
      end
    end
  end
end
