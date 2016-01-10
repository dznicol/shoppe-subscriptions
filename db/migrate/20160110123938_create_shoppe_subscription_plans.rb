class CreateShoppeSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :shoppe_subscription_plans do |t|
      t.integer :product_id
      t.string  :api_plan_id
      t.decimal :amount,        precision: 8, scale: 2
      t.integer :interval
      t.integer :interval_count
      t.string  :name
      t.string  :currency
      t.integer :trial_period

      t.timestamps null: false
    end
  end
end
