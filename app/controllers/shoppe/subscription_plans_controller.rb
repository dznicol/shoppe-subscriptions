module Shoppe
  class SubscriptionPlansController < Shoppe::ApplicationController
    before_action :set_stripe_account
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
        @charging_currencies = Shoppe::ApiHandler.get_currencies(ENV[session[:stripe_account]])
      rescue ::Stripe::InvalidRequestError
        flash[:warning] = t('shoppe.subscription_plans.api_responses.currency_retrieval_failed')
        @charging_currencies = []
      end
    end

    # GET /subscription_plans/1/edit
    def edit
      @subscribable_products = Shoppe::Product.active.with_attributes('subscription', 'true')
      begin
        @charging_currencies = Shoppe::ApiHandler.get_currencies(ENV[session[:stripe_account]])
      rescue ::Stripe::InvalidRequestError
        flash[:warning] = t('shoppe.subscription_plans.api_responses.currency_retrieval_failed')
        @charging_currencies = []
      end
    end

    # POST /subscription_plans
    def create
      begin
        extra = {stripe_api_key: ENV[@stripe_account]}
        @subscription_plan = Shoppe::SubscriptionPlan.new(subscription_plan_params.merge(extra))
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
      if @subscription_plan.update_attributes subscription_plan_params
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
      # Get all API plans for all known Stripe accounts
      ENV.keys.each do |key|
        if key.start_with? 'STRIPE_API_KEY'
          name = get_stripe_account_id(key)
          logger.debug "Loading Stripe subscription plans for account: #{name} (#{key})"
          sync_plans(ENV[key])
        end
      end

      redirect_to subscription_plans_url, notice: t('shoppe.subscription_plans.api_responses.sync_complete')
    end

    def stripe_account
      # Switch Stripe account
      session[:stripe_account] = params[:stripe_account]
      logger.debug "Shoppe::SubscriptionPlansController user set Stripe account to #{session[:stripe_account]}"
      redirect_to request.referer
    end

    private

    def sync_plans(stripe_api_key)
      begin
        @external_plans = Shoppe::ApiHandler.get_subscription_plans(stripe_api_key)
        @external_plans.data.each do |external_plan|
          shoppe_plan = Shoppe::SubscriptionPlan.find_or_create_by(api_plan_id: external_plan.id, currency: external_plan.currency)
          shoppe_plan.amount = Shoppe::ApiHandler.native_amount(external_plan.amount)
          shoppe_plan.interval = external_plan.interval
          shoppe_plan.interval_count = external_plan.interval_count
          shoppe_plan.name = external_plan.name
          shoppe_plan.trial_period_days = external_plan.trial_period_days || 0
          shoppe_plan.stripe_api_key = stripe_api_key
          shoppe_plan.save
        end
      rescue ::Stripe::InvalidRequestError
        flash[:warning] = t('shoppe.subscription_plans.api_responses.plan_sync_failed')
      end
    end

    def get_stripe_account_id(api_key_name)
      matches = api_key_name.match(/STRIPE_API_KEY(_(\w+))?/)
      matches[2] || 'default'
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_subscription_plan
      @subscription_plan = Shoppe::SubscriptionPlan.find(params[:id])

      # Also set the Stripe API Key for API actions on this subscriber
      @subscription_plan.stripe_api_key = ENV[@stripe_account]
    end

    def set_stripe_account
      @stripe_accounts = ['STRIPE_API_KEY', 'STRIPE_API_KEY_US']
      session[:stripe_account] = @stripe_accounts[0] if session[:stripe_account].blank?
      @stripe_account = session[:stripe_account]
      logger.debug "Shoppe::SubscriptionPlans Stripe account is #{session[:stripe_account]}"
    end

    # Only allow a trusted parameter "white list" through.
    def subscription_plan_params
      params.require(:subscription_plan).permit(:amount, :interval, :interval_count, :name, :currency, :trial_period_days, :api_plan_id, :product_id)
    end
  end
end
