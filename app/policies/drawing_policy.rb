class DrawingPolicy < ApplicationPolicy
  def upload?
    user.admin?
  end
end
