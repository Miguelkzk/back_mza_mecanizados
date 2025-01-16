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
  scope :filter_by_issue_date_month, ->(month) { where('EXTRACT(MONTH FROM issue_date) = ?', month.to_i) }
  scope :filter_by_issue_date_year, ->(year) {
  where("CAST(EXTRACT(YEAR FROM issue_date) AS TEXT) LIKE ?", "%#{year}%")
}

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

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      name
      type_maintenance
      issue_date
      issue_date_month
      issue_date_year
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[machine]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %w[filter_by_issue_date_month filter_by_issue_date_year]
  end
end
