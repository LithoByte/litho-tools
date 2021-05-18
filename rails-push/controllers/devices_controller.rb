class Api::V1::DevicesController < Api::V1::ApiController
  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params.merge(user_id: current_user.id))

    if @device.save
      render :show, status: :created
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def device_params
    params.require(:device).permit(:push_id, :platform)
  end
end
