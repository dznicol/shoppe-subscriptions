module Shoppe
  class SubscribersController < Shoppe::ApplicationController
    before_action :set_subscriber, only: [:show, :edit, :update, :destroy]
    before_action :set_subscription_plan

    # GET /subscribers
    def index
      @subscribers = @subscription_plan.subscribers
      @cancelled_subscribers = @subscription_plan.subscribers.unscoped.where.not(cancelled_at: nil)
    end

    # GET /subscribers/1
    def show
    end

    # GET /subscribers/new
    def new
      @subscriber = Subscriber.new
    end

    # GET /subscribers/1/edit
    def edit
    end

    # POST /subscribers
    def create
      @subscriber = Subscriber.new(subscriber_params)

      if @subscriber.save
        redirect_to @subscriber, notice: t('shoppe.subscribers.create_notice')
      else
        render :new
      end
    end

    # PATCH/PUT /subscribers/1
    def update
      if @subscriber.update(subscriber_params)
        redirect_to [@subscription_plan, :subscribers], notice: t('shoppe.subscribers.update_notice')
      else
        render :edit
      end
    end

    # DELETE /subscribers/1
    def destroy
      @subscriber.update_attribute(:cancelled_at, DateTime.now)
      redirect_to [@subscription_plan, :subscribers], notice: t('shoppe.subscribers.cancelled_notice')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_subscriber
        @subscriber = Subscriber.unscoped.find(params[:id])
      end

      def set_subscription_plan
        @subscription_plan = SubscriptionPlan.find(params[:subscription_plan_id])
      end

      # Only allow a trusted parameter "white list" through.
      def subscriber_params
        params.require(:subscriber).permit(:subscriber_plan_id, :customer_id, :recipient_name, :balance, :stripe_id)
      end
  end
end
