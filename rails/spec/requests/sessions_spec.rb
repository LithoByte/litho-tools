require 'rails_helper'

describe 'Session requests' do
  let(:accept_headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
    }
  end

  describe 'POST /api/v1/sessions' do
    it 'creates a session and returns JSON' do
      user = create :user

      session_attributes = {
        email: user.email,
        password: 'bigbarda'
      }.to_json

      post(api_v1_sessions_url, params: session_attributes, headers: accept_headers)

      expect(response).to have_http_status :ok
      expect(body['api_key']).not_to be_nil
    end

    it 'does not login for bad email' do
      user = create :user

      session_attributes = {
        email: "email@gmail.com",
        password: 'bigbarda'
      }.to_json

      post(api_v1_sessions_url, params: session_attributes, headers: accept_headers)

      expect(response).to have_http_status :unauthorized
    end

    it 'does not login for bad password' do
      user = create :user

      session_attributes = {
        email: user.email,
        password: 'wrong'
      }.to_json

      post(api_v1_sessions_url, params: session_attributes, headers: accept_headers)

      expect(response).to have_http_status :unauthorized
    end
  end
end
