class CreateRemunerations < ActiveRecord::Migration[7.1]
  def change
    create_table :remunerations do |t|
      t.float :amount_usd
      t.float :amount_ars
      t.float :exchange_rate
      t.date :date
      t.references :parent, polymorphic: true, null: true
      t.timestamps
    end
  end
end
