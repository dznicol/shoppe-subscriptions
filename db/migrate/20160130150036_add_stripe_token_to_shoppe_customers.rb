class AddStripeTokenToShoppeCustomers < ActiveRecord::Migration
  def change
    add_column :shoppe_customers, :stripe_token, :string
  end
end
