class DeliveryNotePolicy < ApplicationPolicy
  def upload?
    user.admin?
  end
end
