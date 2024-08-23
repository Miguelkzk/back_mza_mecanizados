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

  scope :without_material, -> { where(state: :without_material) }
  scope :with_material_but_not_started, -> { where(state: :with_material_but_not_started) }
  scope :in_progress, -> { where(state: :in_progress) }
  scope :not_invoiced, -> { where(state: :not_invoiced) }
  scope :delivered_and_invoiced, -> { where(state: :delivered_and_invoiced) }
  scope :incomplete, -> { where(state: :incomplete) }

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
