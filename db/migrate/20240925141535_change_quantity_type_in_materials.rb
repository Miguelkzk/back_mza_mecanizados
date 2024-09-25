class ChangeQuantityTypeInMaterials < ActiveRecord::Migration[7.1]
  def change
    change_column :materials, :quantity, :float
  end
end
