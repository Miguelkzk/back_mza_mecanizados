class Machine < ApplicationRecord
  include GenerateSheet
  include GenerateCalendar
  # ASSOCIATIONS
  has_many :maintenances
  ############################################################
  # VALIDATIONS
  ############################################################
  # ENUMS
  ############################################################
  # VALIDATIONS
  ############################################################
  # SCOPES
  ############################################################
  # CALLBACKS
  ############################################################
  # INSTANCE METHODS
  ############################################################
  # CLASS METHODS
  ############################################################
  def self.generate_sheet_routine
    maquina = Machine.first
    maquina.sheet_routine(12, 2022)
  end

  def self.calendar(month, year)
    machine = Machine.first
    machine.generate_calendar(month, year)
  end
end
