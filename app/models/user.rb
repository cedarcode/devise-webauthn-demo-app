class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, authentication_keys: [:username]

  PASSWORD_LENGTH = 6..128

  validates_presence_of     :username
  validates_presence_of     :password
  validates_confirmation_of :password
  validates_length_of       :password, within: PASSWORD_LENGTH, allow_blank: true
end
