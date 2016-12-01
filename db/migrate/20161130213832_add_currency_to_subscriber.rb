class AddCurrencyToSubscriber < ActiveRecord::Migration
  def change
    add_column :shoppe_subscribers, :currency, :string, default: 'gbp', nil: false
  end
end
