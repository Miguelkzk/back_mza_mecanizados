class MaintenancePolicy < ApplicationPolicy
  def upload?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
