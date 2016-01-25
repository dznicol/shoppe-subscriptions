class CreateShoppeSubscribers < ActiveRecord::Migration
  def change
    create_table :shoppe_subscribers do |t|
      t.references :subscription_plan, index: true, foreign_key: true
      t.references :customer, index: true, foreign_key: true
      t.decimal :balance

      t.timestamps null: false
    end
  end
end
