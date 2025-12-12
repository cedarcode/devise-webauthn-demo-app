class WebauthnCredentialsController < ApplicationController
  before_action :authenticate_user!

  def index
    @passkeys = current_user.webauthn_credentials.passkey
    @second_factor_credentials = current_user.webauthn_credentials.second_factor
  end
end
