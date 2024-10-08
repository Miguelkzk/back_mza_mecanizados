class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { viewer: 0, admin: 1 }
  validates :role, presence: true

  def admin?
    role == 'admin'
  end

  def viewer?
    role == 'viewer'
  end
end
