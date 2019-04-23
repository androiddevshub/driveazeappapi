class JsonWebToken
  SECRET_KEY = Rails.application.credentials.devise_jwt_secret_key

  def self.encode(payload, exp = Rails.application.config.jwt_exp_time)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY).first
    HashWithIndifferentAccess.new decoded
  end
end
