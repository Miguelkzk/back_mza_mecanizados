class CreateDrawings < ActiveRecord::Migration[7.1]
  def change
    create_table :drawings do |t|
      t.string :drive_id
      t.string :name
      t.string :view_url

      t.belongs_to :order
      t.timestamps
    end
  end
end
