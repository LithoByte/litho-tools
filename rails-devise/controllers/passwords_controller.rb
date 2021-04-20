class PasswordsController < ActionController::Base
  skip_before_action :verify_authenticity_token, raise: false

  def request_reset
    user = User.find_for_authentication(email: request_password_reset_params[:email])

    user&.send_reset_password_instructions
    render json: { message: "Password reset request received" }, status: :ok
  end

  def reset_password
    user = User.find_by(reset_password_token: update_password_params[:token])

    if user&.reset_password(
      update_password_params[:password],
      update_password_params[:password_confirmation],
    )
      render json: { message: "Successfully updated password" }, status: :ok
    else
      render json: { error: "Could not update password" }, status: :unprocessable_entity
    end
  end

  private

  def request_password_reset_params
    params.require(:user).permit(:email)
  end

  def update_password_params
    params.require(:user).permit(:password_confirmation, :password, :token)
  end
end
