class RemunerationsPolicy < ApplicationPolicy
  def show_parents?
    user.admin?
  end

  def show_childrens?
    user.admin?
  end

  def create_remuneration_for_month?
    user.admin?
  end

  def set_remuneration?
    user.admin?
  end
end