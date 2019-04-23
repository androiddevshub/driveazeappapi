class VerifyController < ApplicationController

  def verify_user
    user = User.find_by_email(params[:email])
    if user.present?
      if user.otp == params[:otp]
        if user.update(verified: "1")
          if user.update(otp: nil)
            render json: { message: 'Successfully verified.' }, status: :ok
          else
            render json: { message: user.errors.full_messages }, status: :bad_request
          end
        else

          render json: { message: user.errors.full_messages }, status: :bad_request
        end
      else
        render json: { message: 'Please enter a valid OTP' }, status: :bad_request
      end
    else
      render json: { message: 'No user found' }, status: :bad_request
    end
  end

  def destroy_user
    user = User.find_by(session_id: request.headers['session-id'])
    if user.present?
      user.session_id = nil
      if user.save
        render json: { message: 'Logged out' }, status: :ok
      else
        render json: {errors: 'Something went wrong'}, status: :bad_request
      end
    else
      render json: { errors: 'Invalid session id' }, status: :bad_request
    end
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
