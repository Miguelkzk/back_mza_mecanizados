class CreateMachines < ActiveRecord::Migration[7.1]
  def change
    create_table :machines do |t|
      t.string :code
      t.string :brand
      t.string :model
      t.float :horsepower
      t.string :routine_detail
      t.string :preventive_detail_annual
      t.string :preventive_detail_biannual
      t.string :drive_id
      t.timestamps
    end
  end
end
