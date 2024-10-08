class CertificateOfMaterialPolicy < ApplicationPolicy
  def upload?
    user.admin?
  end
end
