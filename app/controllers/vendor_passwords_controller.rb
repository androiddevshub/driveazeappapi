class UserPasswordsController < Users::Devise::PasswordsController

  def create
    @user = User.find_by_email(params[:email])
    if @user.present?
      if @user.verified == "1"
       @otp = rand.to_s[2..6]
       if User.find(@user.id).update(otp: @otp)
         # ResetMailer.reset_password_mail(@user, @otp).deliver_now!
         render json: { message: 'Please check your email to reset password.' }, status: :ok
       else
         render json: { errors: 'Something went wrong' }, status: :bad_request
       end
      else
        render json: { errors: 'Please verify your account first.' }, status: :bad_request
      end
    else
      render json: { errors: 'No such user existed' }, status: :bad_request
    end
  end

  def update
    @user = User.find_by(email: params[:user][:email])
    if @user.present?
      if @user.otp == params[:user][:otp]
        if params[:user][:password] == params[:user][:confirm_password]
          if @user.update(password: params[:user][:password])
            @user.otp = nil
            if @user.save
              render json: { message: 'Password reset successfully.' }, status: :created
            else
              render json: { errors: 'Something went wrong' }, status: :bad_request
            end
          else
            render json: { errors: 'Something went wrong' }, status: :bad_request
          end
        else
          render json: { errors: 'Passwords do not match' }, status: :bad_request
        end
      else
        render json: { errors: 'Please enter valid OTP' }, status: :bad_request
      end
     else
       render json: { errors: 'No user registered with this email.' }, status: :bad_request
    end
  end

end
