class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  REGEX_PASSWORD = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%])/
  REGEX_PHONE = /\A\d+\z/

  validates :password, length: { in: 8..16 }, format: { with: REGEX_PASSWORD,
          message: I18n.t('errors.password') } , if: :encrypted_password_changed?

  validates :phone, uniqueness: true, presence: true ,
            format: { with: REGEX_PHONE, message: I18n.t('errors.phone') }

end
