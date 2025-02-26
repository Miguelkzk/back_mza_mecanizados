class SupplierPolicy < ApplicationPolicy
  def index_with_note?
    user.admin? || user.viewer?
  end

  def show_notes?
    user.admin? || user.viewer?
  end
end
