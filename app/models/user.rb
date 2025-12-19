class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
         :passkey_authenticatable, :webauthn_two_factor_authenticatable,
         authentication_keys: [:username]

  PASSWORD_LENGTH = 6..128

  validates_presence_of     :username
  validates_uniqueness_of   :username, case_sensitive: false
  validates_presence_of     :password
  validates_confirmation_of :password
  validates_length_of       :password, within: PASSWORD_LENGTH, allow_blank: true
end
