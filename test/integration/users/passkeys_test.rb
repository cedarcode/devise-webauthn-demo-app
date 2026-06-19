require "test_helper"
require "webauthn/fake_client"

class Users::PasskeysTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "should redirect to sign in when not authenticated" do
    get new_user_passkey_path
    assert_redirected_to new_user_session_path
  end

  test "should get new when authenticated" do
    sign_in @user
    get new_user_passkey_path
    assert_response :success
  end

  test "should create passkey with valid credential" do
    sign_in @user

    # The challenge is now served by a dedicated options endpoint and stored in the session.
    get user_passkey_registration_options_path
    challenge = session[:webauthn_challenge]

    # Create a fake WebAuthn credential
    client = WebAuthn::FakeClient.new(
      WebAuthn.configuration.allowed_origins.first,
      encoding: :base64url
    )
    credential = client.create(challenge: challenge, user_verified: true)

    assert_difference("@user.webauthn_credentials.count", 1) do
      post user_passkeys_path, params: {
        name: "My Passkey",
        public_key_credential: credential.to_json,
      }
    end

    assert_redirected_to root_path
    assert_equal "Passkey created successfully.", flash[:notice]
    assert_nil session[:webauthn_challenge]
  end

  test "should not create passkey with invalid credential" do
    sign_in @user

    get user_passkey_registration_options_path
    challenge = session[:webauthn_challenge]

    # Create credential without user verification (invalid for passkeys)
    client = WebAuthn::FakeClient.new(
      WebAuthn.configuration.allowed_origins.first,
      encoding: :base64url
    )
    credential = client.create(challenge: challenge, user_verified: false)

    assert_no_difference("@user.webauthn_credentials.count") do
      post user_passkeys_path, params: {
        name: "Invalid Passkey",
        public_key_credential: credential.to_json,
      }
    end

    assert_redirected_to root_path
  end

  test "should destroy passkey" do
    sign_in @user
    passkey = @user.webauthn_credentials.create!(
      external_id: "test-passkey-id",
      public_key: "test-public-key",
      name: "Test Passkey",
      sign_count: 0,
      authentication_factor: :first_factor
    )

    assert_difference("@user.webauthn_credentials.count", -1) do
      delete user_passkey_path(passkey)
    end

    assert_redirected_to root_path
  end
end
