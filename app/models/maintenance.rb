class Maintenance < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :machine

  ############################################################
  # ENUMS
  enum type_maintenance: { preventive: 0, corrective: 1, routine: 2 }

  ############################################################
  # VALIDATIONS

  ############################################################
  # SCOPES
  ############################################################
  # CALLBACKS
  ############################################################
  after_create :set_drive_url
  # INSTANCE METHODS
  ############################################################
  def set_drive_url
    url = "https://drive.google.com/file/d/#{drive_id}/view"
    update(view_url: url)
  end
  # CLASS METHODS
  ############################################################
end
