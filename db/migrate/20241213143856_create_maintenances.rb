class CreateMaintenances < ActiveRecord::Migration[7.1]
  def change
    create_table :maintenances do |t|
      t.string :name
      t.datetime :issue_date
      t.integer  :type_maintenance
      t.string :drive_id
      t.string :view_url
      t.belongs_to :machine
      t.timestamps
    end
  end
end
