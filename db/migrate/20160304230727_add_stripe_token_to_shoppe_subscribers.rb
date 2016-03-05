class AddStripeTokenToShoppeSubscribers < ActiveRecord::Migration
  def change
    add_column :shoppe_subscribers, :stripe_token, :string
  end
end
