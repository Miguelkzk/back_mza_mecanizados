class CreateCertificateOfMaterials < ActiveRecord::Migration[7.1]
  def change
    create_table :certificate_of_materials do |t|
      t.string :drive_id
      t.string :name
      t.string :view_url

      t.belongs_to :order
      t.timestamps
    end
  end
end
