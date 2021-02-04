class Api::V1::ApiController < ApplicationController
  before_action :authenticate!

  def current_user
    @current_user
  end

  def authenticate!
    @current_user = User.find_by(api_key: request.headers["X-Api-Key"])
    if @current_user.blank?
      head :unauthorized
    end
  end

  def render_errors(model, status = :unprocessable_entity)
    render json: { errors: model.errors.full_messages },
           status: status
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: exception.message }, status: :not_found
  end
end
