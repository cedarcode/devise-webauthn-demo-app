# frozen_string_literal: true

class Users::SecondFactorWebauthnCredentialsController < Devise::SecondFactorWebauthnCredentialsController
  # GET /resource/passkeys/new
  def new
    @options = WebAuthn::Credential.options_for_create(
      user: {
        id: resource.webauthn_id,
        name: resource.username,
      },
      exclude: resource.webauthn_credentials.pluck(:external_id),
      authenticator_selection: {
        resident_key: "discouraged",
        user_verification: "discouraged"
      }
    )

    # Store challenge in session for later verification
    session[:webauthn_challenge] = @options.challenge
  end
end
