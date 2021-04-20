class Api::V1::ApiController < ApplicationController
  before_action :authenticate_user!

  def render_errors(model, status = :unprocessable_entity)
    render json: { errors: model.errors.full_messages },
           status: status
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: exception.message }, status: :not_found
  end
end
