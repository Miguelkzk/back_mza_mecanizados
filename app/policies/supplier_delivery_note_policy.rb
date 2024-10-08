class SupplierDeliveryNotePolicy < ApplicationPolicy
  def upload?
    user.admin?
  end
end
