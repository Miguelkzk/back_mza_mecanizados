class AddUniqueIndexToWorkOrders < ActiveRecord::Migration[7.1]
  def change
    remove_index :work_orders, :order_id if index_exists?(:work_orders, :order_id)
    add_index :work_orders, :order_id, unique: true
  end
end
