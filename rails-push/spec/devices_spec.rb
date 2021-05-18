require 'rails_helper'

RSpec.describe "Api::V1::Devices", type: :request do
  let(:body) { json_response }
  let(:user) { create :user }
  let(:headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
    }
  end
  let(:valid_headers) { create_auth_headers(headers, user) }
  let(:valid_attributes) {
    {
      push_id: "onesignal",
      platform: "ios",
    }
  }

  let(:invalid_attributes) {
    { platform: "ios" }
  }

  describe "POST /create" do
    before :each do
      response = Rack::Response.new
      response.body = {id: 1}.to_json

      allow(OneSignal::Player).to receive(:create)
        .and_return(response)
    end
    context "with valid parameters" do
      it "creates a new Device" do
        expect {
          post api_v1_devices_url,
               params: { device: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Device, :count).by(1)
      end

      it "renders a JSON response with the new device" do
        post api_v1_devices_url,
             params: { device: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Device" do
        expect {
          post api_v1_devices_url,
               params: { device: invalid_attributes }, as: :json
        }.to change(Device, :count).by(0)
      end

      it "renders a JSON response with errors for the new device" do
        post api_v1_devices_url,
             params: { device: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with invalid headers" do
      it "does not create a new Device" do
        expect {
          post api_v1_devices_url,
               params: { device: invalid_attributes }, as: :json
        }.to change(Device, :count).by(0)
      end

      it "returns unauthorized" do
        post api_v1_devices_url,
             params: { device: valid_attributes }, headers: headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
