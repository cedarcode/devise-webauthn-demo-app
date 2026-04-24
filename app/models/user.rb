class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
         :passkey_authenticatable, :two_factor_authenticatable, two_factor_methods: [:webauthn, :otp],
         authentication_keys: [:username]

  PASSWORD_LENGTH = 6..128

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, confirmation: true, length: { within: PASSWORD_LENGTH }, allow_blank: true

  def otp_provisioning_identifier
    username
  end
end
