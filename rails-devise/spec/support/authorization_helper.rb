module AuthorizationHelper
  def decode_jwt_token(response)
    token_from_response = response
      .headers["Authorization"]
      .split(" ")
      .last

    JWT.decode(
      token_from_response,
      ENV["DEVISE_JWT_SECRET_KEY"],
      true,
    )
  end
end
