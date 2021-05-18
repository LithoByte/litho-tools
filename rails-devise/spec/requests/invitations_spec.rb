require "rails_helper"

RSpec.describe "Invitations", type: :request do
  describe "PATCH /invitation" do
    let(:body) { json_response }
    let(:first_name) { "Scott" }
    let(:last_name) { "Free" }
    let(:password) { "BigBardaFan" }
    let(:headers) do
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
      }
    end
    let(:params) do
      {
        accept_invitation: {
          first_name: first_name,
          last_name: last_name,
          password: password,
          password_confirmation: password_confirmation,
          invitation_token: invite_token,
        },
      }
    end

    context "when there is a user with a matching token" do
      let(:invite_token) { User.invite!(email: "mrmiracle@example.com").raw_invitation_token }

      context "and valid params" do
        let(:password_confirmation) { password }
        let(:url) { "/api/v1/invitation" }

        before { patch url, params: params.to_json, headers: headers }

        it "returns 200" do
          expect(response.status).to eq 200
        end

        it "returns user" do
          expect(body).to match_json_schema("user")
        end

        it "returns JWT token in the response body" do
          expect(response.body["api_key"]).to be_present
        end
      end

      context "with invalid params" do
        let(:password_confirmation) { "#{password}12345" }
        let(:url) { "/api/v1/invitation" }

        before { patch url, params: params.to_json, headers: headers }

        it "returns 400" do
          expect(response.status).to eq 400
        end
      end
    end

    context "when no user matches the token" do
      let(:password_confirmation) { password }
      let(:invite_token) { "Invite Token!" }
      let(:url) { "/api/v1/invitation" }

      before { patch url, params: params.to_json, headers: headers }

      it "returns 404" do
        expect(response.status).to eq 404
      end

      it "returns a meaningful error" do
        expect(body["error"]).to eq("User not found.")
      end
    end
  end
end
