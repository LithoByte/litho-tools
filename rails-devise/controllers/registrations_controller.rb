class RegistrationsController < Devise::RegistrationsController
  include AuthToken
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.errors.empty?
      sign_in(resource)
      render json: UserBlueprint.render(
        resource,
        view: :with_auth,
        auth_token: auth_token
        )
    else
      validation_error(resource)
    end
  end

  private

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: "400",
          title: "Bad Request",
          detail: resource.errors,
        },
      ],
    }, status: :bad_request
  end
end
