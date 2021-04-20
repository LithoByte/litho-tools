require 'rails_helper'

RSpec.describe "POST /login", type: :request do
  let(:url) { "/api/v1/login" }
  let(:accept_headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
    }
  end
  let(:decoded_token) { decode_jwt_token(response) }

  describe 'POST /api/v1/login' do
    it 'creates a session and returns JSON' do
      user = create :user

      session_attributes = {
          user: {
            email: user.email,
            password: user.password,
          }
      }.to_json

      post(url, params: session_attributes, headers: accept_headers)

      expect(response).to have_http_status :ok
      expect(body['api_key']).not_to be_nil
      expect(decoded_token.first["sub"]).to be_present
    end

    it 'does not login for bad email' do
      user = create :user

      session_attributes = {
        email: "email@gmail.com",
        password: 'bigbarda'
      }.to_json

      post(url, params: session_attributes)

      expect(response).to have_http_status :unauthorized
    end

    it 'does not login for bad password' do
      user = create :user

      session_attributes = {
        email: user.email,
        password: 'wrong'
      }.to_json

      post(url, params: session_attributes, headers: accept_headers)

      expect(response).to have_http_status :unauthorized
    end
  end
end
