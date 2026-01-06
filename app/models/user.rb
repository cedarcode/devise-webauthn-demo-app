class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
    :passkey_authenticatable, :webauthn_two_factor_authenticatable,
    authentication_keys: [:username]

  PASSWORD_LENGTH = 6..128

  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, confirmation: true, length: {within: PASSWORD_LENGTH}, allow_blank: true
end
