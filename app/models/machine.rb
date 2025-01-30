class Machine < ApplicationRecord
  include GenerateSheet
  include GenerateCalendar
  # ASSOCIATIONS
  has_many :maintenances

  # ENUMS
  ############################################################
  # VALIDATIONS
  ############################################################
  validates :code, :brand, :model, :horsepower, :routine_detail,
            :preventive_detail_annual, :preventive_detail_biannual, presence: true

  validates :code, uniqueness: true
  validates :horsepower, numericality: { greater_than: 0 }

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
end
