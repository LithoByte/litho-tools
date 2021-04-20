class Api::V1::UsersController < Api::V1::ApiController
  include AuthToken
  skip_before_action :authenticate_user!, only: [:create]

  def create
    @user = User.create(user_params)

    if @user.id
      sign_in(:user, @user)
      @auth_token = auth_token
      render :create, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :password
    )
  end
end
