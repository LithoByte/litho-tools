require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:body) { json_response }
  let(:user) { create :user }
  let(:headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
    }
  end
  let(:auth_headers) { create_auth_headers(headers, user) }

  describe "POST /api/v1/users" do
    subject(:url) { api_v1_users_url }
    let(:email) { "MrMiracle@example.com" }
    let(:first_name) { "Mister" }
    let(:last_name) { "Miracle" }
    let(:password) { "password" }
    let(:params) {
      {
        user: {
          email: email,
          first_name: first_name,
          last_name: last_name,
          password: password,
        }
      }
    }

    it "creates a User" do
      expect do
        post url, params: params.to_json, headers: headers
      end.to change { User.count }.by(1)
    end
    
    it "returns a JSON object representing the field user" do
      post url, params: params.to_json, headers: headers

      expect(response).to have_http_status(201)
      expect(body["email"]).to eq(email)
      expect(body["first_name"]).to eq(first_name)
      expect(body["last_name"]).to eq(last_name)
      expect(body["api_key"]).to eq(User.last.api_key)
      expect(body).to match_json_schema("user")
    end
  end
end
