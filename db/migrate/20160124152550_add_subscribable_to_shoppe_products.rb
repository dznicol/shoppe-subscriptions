class AddSubscribableToShoppeProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :subscribable, :boolean, default: false
  end
end
