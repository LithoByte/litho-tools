require 'rails_helper'

RSpec.describe Device, type: :model do
  subject { build :device }
  before :each do
    response = Rack::Response.new
    response.body = {id: 1}.to_json

    allow(OneSignal::Player).to receive(:create)
      .and_return(response)
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:push_id) }
    it { is_expected.to validate_uniqueness_of(:push_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "register" do
    it "registers after save" do
      user = create :user
      device = Device.new(push_id: "onesignal", platform: "ios", user_id: user.id)

      device.save

      expect(OneSignal::Player).to have_received(:create)
    end

    it "does not register before save" do
      user = create :user

      device = Device.new(push_id: "onesignal", platform: "ios", user_id: user.id)

      expect(OneSignal::Player).not_to have_received(:create)
    end

    it "sets player id on user" do
      user = create :user
      device = Device.new(push_id: "onesignal", platform: "ios", user_id: user.id)

      device.save
      
      user.reload
      expect(user.push_provider_id).to eq "1"
    end

    it "does not set player id on user with existing player id" do
      user = create :user, push_provider_id: 2
      device = Device.new(push_id: "onesignal", platform: "ios", user_id: user.id)

      device.save
      
      user.reload
      expect(user.push_provider_id).not_to eq(1)
    end
  end
end
