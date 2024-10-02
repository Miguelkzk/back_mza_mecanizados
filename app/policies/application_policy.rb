class ApplicationPolicy
  attr_reader :current_user, :record

  def initialize(current_user, record)
    @current_user = current_user
    @record = record
  end

  def index?
    current_user.admin? || current_user.viewer?
  end

  def show?
    current_user.admin? || current_user.viewer?
  end

  def create?
    current_user.admin?
  end

  def update?
    current_user.admin?
  end

  def destroy?
    current_user.admin?
  end
end
