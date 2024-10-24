class FilePurchaseOrderPolicy < ApplicationPolicy
  def upload?
    user.admin?
  end
end
