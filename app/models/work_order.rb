class WorkOrder < ApplicationRecord
  ############################################################################################
  # ASSOCIATIONS
  ############################################################################################

  belongs_to :order

  ############################################################################################
  # VALIDATIONS
  ############################################################################################

  ############################################################################################
  # SCOPES
  ############################################################################################

  ############################################################################################
  # CALLBACKS
  ############################################################################################
  after_create :set_drive_url
  before_destroy :delete_file_from_drive

  ############################################################################################
  # INSTANCE METHODS
  ############################################################################################

  def upload_work_order(name, file, parent_id)
    @drive_service = GoogleDriveService.new
    uploaded_file = @drive_service.upload_file(name, file, parent_id)
    if uploaded_file.is_a?(Google::Apis::DriveV3::File)
      self.name = uploaded_file.name
      self.drive_id = uploaded_file.id
      self.save!
    end
  end

  def set_drive_url
    url = "https://drive.google.com/file/d/#{drive_id}/view"
    update(view_url: url)
  end

  def delete_file_from_drive
    @drive_service = GoogleDriveService.new
    @drive_service.delete_file(drive_id)
  end
  ############################################################################################
  # CLASS METHODS
  ############################################################################################
end
