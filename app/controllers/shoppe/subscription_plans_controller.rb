module Shoppe
  class SubscriptionPlansController < Shoppe::ApplicationController
    before_action :set_subscription_plan, only: [:show, :edit, :update, :destroy]

    before_filter { @active_nav = :subscription_plans }
    # before_filter { params[:id] && @subscription_plan = Shoppe::SubscriptionPlan.find(params[:id]) }

    # GET /subscription_plans
    def index
      @subscription_plans = Shoppe::SubscriptionPlan.all
    end

    # GET /subscription_plans/1
    def show
    end

    # GET /subscription_plans/new
    def new
      @subscription_plan = Shoppe::SubscriptionPlan.new
      @subscribable_products = Shoppe::Product.active.with_attributes('subscription', 'true')
      begin
        @charging_currencies = Shoppe::ApiHandler.get_currencies
      rescue ::Stripe::InvalidRequestError
        flash[:warning] = t('shoppe.subscription_plans.api_responses.currency_retrieval_failed')
        @charging_currencies = []
      end
    end

    # GET /subscription_plans/1/edit
    def edit
      @subscribable_products = Shoppe::Product.active.with_attributes('subscription', 'true')
      begin
        @charging_currencies = Shoppe::ApiHandler.get_currencies
      rescue ::Stripe::InvalidRequestError
        flash[:warning] = t('shoppe.subscription_plans.api_responses.currency_retrieval_failed')
        @charging_currencies = []
      end
    end

    # POST /subscription_plans
    def create
      begin
        @subscription_plan = Shoppe::SubscriptionPlan.new(subscription_plan_params)
      rescue ::Stripe::InvalidRequestError => e
        flash[:warning] = e.message
      end

      if @subscription_plan.save
        redirect_to @subscription_plan, notice: t('shoppe.subscription_plans.api_responses.plan_created')
      else
        render :new
      end
    end

    # PATCH/PUT /subscription_plans/1
    def update
      # Only name can be updated as that is what our payment provider (stripe) allows.
      # FIXME We need to add statement_descriptor as that can be updated too
      if @subscription_plan.update_attribute(:name, subscription_plan_params[:name])
        redirect_to @subscription_plan, notice: t('shoppe.subscription_plans.api_responses.plan_updated')
      else
        render :edit
      end
    end

    # DELETE /subscription_plans/1
    def destroy
      @subscription_plan.destroy
      redirect_to subscription_plans_url, notice: t('shoppe.subscription_plans.api_responses.plan_destroyed')
    end

    # SYNC with plans provider
    def sync
      begin
        @external_plans = Shoppe::ApiHandler.get_subscription_plans
        @external_plans.data.each do |external_plan|
          shoppe_plan = Shoppe::SubscriptionPlan.find_or_create_by(api_plan_id: external_plan.id)
          shoppe_plan.amount = Shoppe::ApiHandler.native_amount(external_plan.amount)
          shoppe_plan.currency = external_plan.currency
          shoppe_plan.interval = external_plan.interval
          shoppe_plan.interval_count = external_plan.interval_count
          shoppe_plan.name = external_plan.name
          shoppe_plan.trial_period_days = external_plan.trial_period_days || 0
          shoppe_plan.save
        end

      rescue ::Stripe::InvalidRequestError
        flash[:warning] = t('shoppe.subscription_plans.api_responses.plan_sync_failed')
      end
      redirect_to subscription_plans_url, notice: t('shoppe.subscription_plans.api_responses.sync_complete')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_subscription_plan
        @subscription_plan = Shoppe::SubscriptionPlan.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def subscription_plan_params
        params.require(:subscription_plan).permit(:amount, :interval, :interval_count, :name, :currency, :trial_period_days, :api_plan_id, :product_id)
      end
  end
end
