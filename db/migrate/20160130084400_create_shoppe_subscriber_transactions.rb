class CreateShoppeSubscriberTransactions < ActiveRecord::Migration
  def change
    create_table :shoppe_subscriber_transactions do |t|
      t.decimal :amount
      t.integer :type
      t.datetime :received_at
      t.integer :subscriber_id

      t.timestamps null: false
    end

    add_index 'shoppe_subscriber_transactions', ['subscriber_id'], name: 'index_shoppe_subscriber_transactions_on_subscriber_id'
  end
end
