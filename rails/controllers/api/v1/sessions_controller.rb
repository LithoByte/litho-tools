class Api::V1::SessionsController < ApplicationController
  def create
    @user = User.where(email: session_params[:email]).first
    if @user
      if @user.authenticate(session_params[:password])
        render :create, status: :ok
      else
        render json: { :errors => "Invalid email or password" }.to_json, :status => :unauthorized
      end
    else
      render json: { :errors => "Invalid email or password" }.to_json, :status => :unauthorized
    end
  end

  private 

  def session_params
    params.permit :email, :password
  end
end
