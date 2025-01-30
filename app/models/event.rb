class Event < ApplicationRecord
  # VALIDATIONS
  #############################################
  validates :title, :start, presence: true
end
