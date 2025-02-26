class CreateAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :assessments do |t|
      t.float :quality_note
      t.float :ponderation_quality
      t.float :cost_note
      t.float :ponderation_cost
      t.float :delivery_note
      t.float :ponderation_delivery
      t.float :service_note
      t.float :ponderation_service
      t.float :methods_of_payment_note
      t.float :ponderation_methods_of_payment
      t.float :total_note
      t.datetime :assessed_at

      t.belongs_to :supplier
      t.timestamps
    end
  end
end
