class CreateShoppeGifts < ActiveRecord::Migration
  def change
    create_table :shoppe_gifts do |t|
      t.integer :product_id
      t.integer :subscriber_id
      t.boolean :claimed, null: false, default: false

      t.timestamps null: false
    end

    add_index :shoppe_gifts, :product_id
    add_foreign_key :shoppe_gifts, :shoppe_products, column: :product_id

    add_index :shoppe_gifts, :subscriber_id
    add_foreign_key :shoppe_gifts, :shoppe_subscribers, column: :subscriber_id
  end
end
