class Device < ApplicationRecord
  belongs_to :user

  validates :push_id, presence: true, uniqueness: true

  after_save :register

  private

  def register
    response = OneSignal::Player.create(params: device_params)
    player_id = JSON.parse(response.body)["id"]

    if self.user && !self.user.push_provider_id
      self.user.push_provider_id = player_id
      self.user.save
    end
  end

  def device_params
    params = {
      app_id: ENV["ONESIGNAL_APP_ID"],
      identifier: self.push_id,
      device_type: device_type
    }

    if self.user && self.user.push_provider_id
      params[:tags] = { user_id: self.user.push_provider_id }
    end

    params
  end

  def device_type
    self.platform == "android" ? 1 : 0
  end
end
