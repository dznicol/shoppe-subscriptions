class CreateShoppeSubscribers < ActiveRecord::Migration
  def change
    create_table :shoppe_subscribers do |t|
      t.integer :subscription_plan_id
      t.integer :customer_id
      t.decimal :balance, default: 0, null: false

      t.timestamps null: false
    end

    add_index 'shoppe_subscribers', ['subscription_plan_id'], name: 'index_shoppe_subscribers_on_subscription_plan_id'
    add_index 'shoppe_subscribers', ['customer_id'], name: 'index_shoppe_subscribers_on_customer_id'
  end
end
