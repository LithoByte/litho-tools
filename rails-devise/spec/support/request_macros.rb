require "devise/jwt/test_helpers"

module RequestMacros
  def create_auth_headers(headers, user)
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end

  def json_response
    JSON.parse(response.body)
  end
end
