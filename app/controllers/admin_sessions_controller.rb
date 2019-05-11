class AdminSessionsController < Devise::SessionsController

  def create
    admin = Admin.find_by_email(sign_in_params[:email])
    if admin.present?
      if admin && admin.valid_password?(sign_in_params[:password]) &&  sign_in(:admin, admin)
        token = JsonWebToken.encode(admin_id: admin.id)
        if admin.update(session_id: token)
          render json: { message: 'Signed in successfully',user: admin.as_json(only: [:id, :name, :email, :phone, :session_id])}, status: :ok
        else
          render json: { errors: admin.errors.full_messages }, status: :bad_request
        end
      else
        render json: { errors: 'Email or password is invalid' }, status: :unauthorized
      end
    else
      render json: { errors: 'No such user exist.' }, status: :bad_request
    end
  end
end
