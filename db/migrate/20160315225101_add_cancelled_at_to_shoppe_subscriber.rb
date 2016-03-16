class AddCancelledAtToShoppeSubscriber < ActiveRecord::Migration
  def change
    add_column :shoppe_subscribers, :cancelled_at, :datetime, default: nil, nil: true
  end
end
