class AddRecipientDetailsToSubscriber < ActiveRecord::Migration
  def change
    add_column :shoppe_subscribers, :recipient_name, :string
    add_column :shoppe_subscribers, :recipient_email, :string
    add_column :shoppe_subscribers, :recipient_phone, :string
  end
end
