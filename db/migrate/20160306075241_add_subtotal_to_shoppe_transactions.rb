class AddSubtotalToShoppeTransactions < ActiveRecord::Migration
  def change
    rename_column :shoppe_subscriber_transactions, :amount, :total
    add_column :shoppe_subscriber_transactions, :subtotal, :decimal
    add_column :shoppe_subscriber_transactions, :discount_code, :string
  end
end
