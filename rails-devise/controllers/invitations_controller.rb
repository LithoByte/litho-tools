class InvitationsController < Devise::InvitationsController
  include AuthToken
  before_action :verify_user_exists, only: :update

  def update
    user.assign_attributes(user_invite_accepting_params)
    user.accept_invitation!

    if user.errors.any?
      render status: :bad_request
    else
      sign_in(:user, user)
      serialized_user = UserBlueprint.render(
        user,
        view: :with_auth,
        auth_token: auth_token,
      )
      render json: serialized_user
    end
  end

  private

  def verify_user_exists
    render json: { error: "User not found." }, status: :not_found unless user
  end

  def user
    @_user ||= User.find_by_invitation_token(invitation_token, true)
  end

  def invitation_token
    user_invite_accepting_params[:invitation_token]
  end

  def user_invite_accepting_params
    params.require(:accept_invitation)
      .permit(:first_name, :last_name, :password, :password_confirmation, :invitation_token)
  end
end
