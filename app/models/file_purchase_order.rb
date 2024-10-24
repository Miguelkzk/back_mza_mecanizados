class FilePurchaseOrder < ApplicationRecord
  ################################################################################################
  # CALLBACKS
  after_create :set_drive_url
  before_destroy :delete_drive_file
  ################################################################################################

  # ASSOCIATIONS
  ################################################################################################
  belongs_to :order
  ################################################################################################

  ################################################################################################
  # INSTANCE METHODS
  ################################################################################################
  def set_drive_url
    url = "https://drive.google.com/file/d/#{drive_id}/view"
    update(view_url: url)
  end

  def delete_drive_file
    google_drive = GoogleDriveService.new
    google_drive.delete_file(drive_id)
  end
end
