class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  before_create :set_api_key

  def set_api_key
    self.api_key = SecureRandom.urlsafe_base64
  end
end
