require 'test_helper'

module Shoppe
  class SubscriptionPlansControllerTest < ActionController::TestCase
    setup do
      @subscription_plan = shoppe_subscription_plans(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:subscription_plans)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create subscription_plan" do
      assert_difference('SubscriptionPlan.count') do
        post :create, subscription_plan: { amount: @subscription_plan.amount, currency: @subscription_plan.currency, interval: @subscription_plan.interval, interval_count: @subscription_plan.interval_count, name: @subscription_plan.name, trial_period: @subscription_plan.trial_period }
      end

      assert_redirected_to subscription_plan_path(assigns(:subscription_plan))
    end

    test "should show subscription_plan" do
      get :show, id: @subscription_plan
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @subscription_plan
      assert_response :success
    end

    test "should update subscription_plan" do
      patch :update, id: @subscription_plan, subscription_plan: { amount: @subscription_plan.amount, currency: @subscription_plan.currency, interval: @subscription_plan.interval, interval_count: @subscription_plan.interval_count, name: @subscription_plan.name, trial_period: @subscription_plan.trial_period }
      assert_redirected_to subscription_plan_path(assigns(:subscription_plan))
    end

    test "should destroy subscription_plan" do
      assert_difference('SubscriptionPlan.count', -1) do
        delete :destroy, id: @subscription_plan
      end

      assert_redirected_to subscription_plans_path
    end
  end
end
