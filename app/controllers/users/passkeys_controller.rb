# frozen_string_literal: true

class Users::PasskeysController < Devise::PasskeysController
  def new
    @options ||= begin
      options = WebAuthn::Credential.options_for_create(
        user: {
          id: resource.webauthn_id,
          name: resource.username
        },
        exclude: resource.passkeys.pluck(:external_id),
        authenticator_selection: {
          resident_key: "required",
          user_verification: "required"
        }
      )

      # Store challenge in session for later verification
      session[:webauthn_challenge] = options.challenge

      options
    end
  end
end
