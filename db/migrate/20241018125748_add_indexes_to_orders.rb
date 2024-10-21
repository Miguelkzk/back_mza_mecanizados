class AddIndexesToOrders < ActiveRecord::Migration[7.1]
  def change
    add_index :orders, :state
    add_index :orders, :purchase_order
    add_index :orders, :name

    add_index :clients, :name
  end
end
