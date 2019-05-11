class UserDashboardsController < ApplicationController

  before_action :authorize_request

  def index
    render json: { data: { name: current_user.name } }, status: :ok
  end

  def user_logged_in
    user = User.find_by(session_id: request.headers['session-id'])
    if user.present?
      render json: { message: 'Logged in', code: 1 }, status: :ok
    else
      render json: { errors: 'Invalid session id' }, status: :bad_request
    end
  end
end
