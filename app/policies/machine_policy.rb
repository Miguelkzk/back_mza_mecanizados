class MachinePolicy < ApplicationPolicy
  def generate_routine_sheet?
    user.admin?
  end

  def generate_preventive_sheet?
    user.admin?
  end

  def generate_corrective_sheet?
    user.admin?
  end

  def show_maintenances?
    user.admin?
  end
end
