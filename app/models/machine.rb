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
  after_create :create_folder
  ############################################################
  # INSTANCE METHODS
  ############################################################

  PARENT_ID = '1DiFe65v0N4a5a1dKSWj1vIk0-Y6-iJPp'

  def create_folder
    drive_service = GoogleDriveService.new
    folder = drive_service.create_folder(code, PARENT_ID)
    update(drive_id: folder.id)
  end

  # CLASS METHODS
  ############################################################
  def self.metodo
    machine = Machine.first
    machine.sheet_preventive
  end
end
