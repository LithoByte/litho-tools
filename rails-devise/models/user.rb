class User < ApplicationRecord
  devise :async, :invitable, :database_authenticatable,
    :registerable, :recoverable, :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: JwtBlacklist

  validates :email, presence: true
end
