class OrderPolicy < ApplicationPolicy
  def materials_in_order?
    user.admin? || user.viewer?
  end

  def generate_work_order?
    user.admin?
  end
end
