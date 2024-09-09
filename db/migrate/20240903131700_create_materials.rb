class CreateMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :materials do |t|
      t.string :description
      t.integer :quantity
      t.string :supplier_note
      t.datetime :ingresed_at

      t.belongs_to :supplier
      t.belongs_to :order
      t.timestamps
    end
  end
end
