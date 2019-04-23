class RegistrationsController < Devise::RegistrationsController

  # skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        @otp = rand.to_s[2..6]
        if resource.update(otp: @otp)
          # UserMailer.send_verify_mail(resource, @otp).deliver
          render json: { user: resource.as_json(only: [:id, :email, :phone]), message: 'signed up successfully' }, status: :created
        else
          render json: { errors: resource.errors }, status: :bad_request
        end
      else
        expire_data_after_sign_in!
        render json: { user: resource.as_json(only: [:id, :email, :phone]), message: 'signed up but inactive' }, status: :forbidden
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: { message: 'resource not saved', errors: resource.errors.full_messages }, status: :bad_request
    end
  end


end
