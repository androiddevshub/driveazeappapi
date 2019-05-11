class UserSessionsController < Devise::SessionsController

  def create
    user = User.find_by_email(sign_in_params[:email])
    if user.present?
      if user.verified == "1"
        if user && user.valid_password?(sign_in_params[:password]) &&  sign_in(:user, user)
          
          token = JsonWebToken.encode(user_id: user.id)
          if user.update(session_id: token)
            render json: { message: 'Signed in successfully',user: user.as_json(only: [:id, :name, :email, :phone, :session_id])}, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :bad_request
          end
        else
          render json: { errors: 'Email or password is invalid' }, status: :unauthorized
        end
      else
        render json: { errors: 'Please verify your account.' }, status: :bad_request
      end
    else
      render json: { errors: 'No such user exist.' }, status: :bad_request
    end
  end
end
