class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :purchase_order
      t.integer :quantity
      t.datetime :ingresed_at
      t.datetime :delivery_at
      t.float :unit_price
      t.string :comment
      t.integer :state
      t.integer :currency

      t.string :drive_id

      t.belongs_to :client
      t.timestamps
    end
  end
end
