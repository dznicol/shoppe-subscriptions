class AddCurrencyToSubscriber < ActiveRecord::Migration
  def change
    add_column :shoppe_subscribers, :currency, :string
  end
end
