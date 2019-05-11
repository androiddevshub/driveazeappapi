class AdminDashboardsController < ApplicationController

  before_action :authorize_admin

  def index
    render json: { data: { name: User.all } }, status: :ok
  end

  def user_logged_in
    admin = Admin.find_by(session_id: request.headers['session-id'])
    if admin.present?
      render json: { message: 'Logged in', code: 1 }, status: :ok
    else
      render json: { errors: 'Invalid session id' }, status: :bad_request
    end
  end
end
