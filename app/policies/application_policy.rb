class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user_present? && (user.admin? || user.viewer?)
  end

  def show?
    user_present? && (user.admin? || user.viewer?)
  end

  def create?
    user_present? && user.admin?
  end

  def update?
    user_present? && user.admin?
  end

  def destroy?
    user_present? && user.admin?
  end

  private

  def user_present?
    user.present?
  end
end
