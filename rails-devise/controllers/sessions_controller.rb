class SessionsController < Devise::SessionsController
  include AuthToken
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    @user = resource
    @auth_token = auth_token
    render :create, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end
