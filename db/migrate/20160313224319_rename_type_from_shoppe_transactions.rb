class RenameTypeFromShoppeTransactions < ActiveRecord::Migration
  def change
    remove_column :shoppe_subscriber_transactions, :type
    add_column :shoppe_subscriber_transactions, :transaction_type, :string
  end
end
