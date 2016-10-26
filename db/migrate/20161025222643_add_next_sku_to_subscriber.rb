class AddNextSkuToSubscriber < ActiveRecord::Migration
  def change
    add_column :shoppe_subscribers, :next_sku, :string
  end
end
