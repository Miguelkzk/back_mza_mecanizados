class Remuneration < ApplicationRecord
  ############################################################################################
  # ASSOCIATIONS
  ############################################################################################
  belongs_to :parent, polymorphic: true, optional: true
  has_many :remunerations, as: :parent

  ############################################################################################
  # CLASS METHODS
  # ############################################################################################

  def self.search_parent(year)
    date = Date.new(year, 1, 1)
    Remuneration.find_by(parent_id: nil, parent_type: nil, date: date.beginning_of_month..date.end_of_month)
  end
end
