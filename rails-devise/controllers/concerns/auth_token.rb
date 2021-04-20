module AuthToken
  extend ActiveSupport::Concern

  def auth_token
    request.env["warden-jwt_auth.token"]
  end
end
