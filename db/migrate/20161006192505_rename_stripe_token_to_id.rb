class RenameStripeTokenToId < ActiveRecord::Migration
  def change
    rename_column :shoppe_subscribers, :stripe_token, :stripe_id
    rename_column :shoppe_customers, :stripe_token, :stripe_id
  end
end
