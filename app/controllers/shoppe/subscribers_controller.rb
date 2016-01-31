module Shoppe
  class SubscribersController < Shoppe::ApplicationController
    before_action :set_subscriber, only: [:show, :edit, :update, :destroy]

    # GET /subscribers
    def index
      @subscribers = Subscriber.all
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
      @@subscriber = Subscriber.new(subscriber_params)

      if @@subscriber.save
        redirect_to @@subscriber, notice: 'Subscriber was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /subscribers/1
    def update
      if @@subscriber.update(subscriber_params)
        redirect_to @@subscriber, notice: 'Subscriber was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /subscribers/1
    def destroy
      @@subscriber.destroy
      redirect_to subscribers_url, notice: 'Subscriber was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_subscriber
        @@subscriber = Subscriber.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def subscriber_params
        params.require(:subscriber).permit(:subscriber_plan_id, :customer_id, :balance)
      end
  end
end
