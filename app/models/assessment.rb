class Assessment < ApplicationRecord
  # ASSOCIATIONS
  ############################################################################################
  belongs_to :supplier

  ############################################################################################
  # CALLBACKS
  ############################################################################################
  after_create :calculate_total_note
  after_update :calculate_total_note
  ############################################################################################
  # INSTANCE METHODS
  ############################################################################################

  def calculate_total_note
    note = (quality_note * ponderation_quality) + (cost_note * ponderation_cost) +
           (delivery_note * ponderation_delivery) + (service_note * ponderation_service) +
           (methods_of_payment_note * ponderation_methods_of_payment)
    update_column(:total_note, note)
  end

  ############################################################################################
  # CLASS METHODS
  ############################################################################################
end
