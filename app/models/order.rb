class Order < ApplicationRecord
  # ENUMS
  enum state: { without_material: 0, with_material_but_not_started: 1, in_progress: 2,
                not_invoiced: 3, delivered_and_invoiced: 4, incomplete: 5 }
  enum currency: { ars: 0, usd: 1 }

  # ASSOCIATIONS
  belongs_to :client
  has_many :drawings

  ############################################################################################
  # VALIDATIONS
  ############################################################################################

  ############################################################################################
  # SCOPES
  ############################################################################################

  ############################################################################################
  # CALLBACKS
  ############################################################################################
  after_create :create_folder
  ############################################################################################
  # INSTANCE METHODS
  ############################################################################################

  def create_folder
    drive_service = GoogleDriveService.new
    folder_name = self.name
    parent_id = '1ucIa7E9E3eG7ldf5ckqKZoVXTHf0qZcq'
    folder = drive_service.create_folder(folder_name, parent_id)
    self.update(drive_id: folder.id)
  end

  ############################################################################################
  # CLASS METHODS
  ############################################################################################
end
