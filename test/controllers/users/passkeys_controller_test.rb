require "application_controller_test_case"
require "webauthn/fake_client"

class Users::PasskeysControllerTest < ApplicationControllerTestCase
  setup do
    @user = users(:one)
  end

  test "should redirect to sign in when not authenticated" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get new when authenticated" do
    sign_in @user
    get :new
    assert_response :success
    assert_not_nil session[:webauthn_challenge]
  end

  test "should create passkey with valid credential" do
    sign_in @user

    # First, get the new page to set up a challenge
    get :new
    challenge = session[:webauthn_challenge]

    # Create a fake WebAuthn credential
    client = WebAuthn::FakeClient.new(
      WebAuthn.configuration.allowed_origins.first,
      encoding: :base64url
    )
    credential = client.create(challenge: challenge, user_verified: true)

    assert_difference("@user.webauthn_credentials.count", 1) do
      post :create, params: {
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

    # Get challenge
    get :new
    challenge = session[:webauthn_challenge]

    # Create credential without user verification (invalid for passkeys)
    client = WebAuthn::FakeClient.new(
      WebAuthn.configuration.allowed_origins.first,
      encoding: :base64url
    )
    credential = client.create(challenge: challenge, user_verified: false)

    assert_no_difference("@user.webauthn_credentials.count") do
      post :create, params: {
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
      delete :destroy, params: {id: passkey.id}
    end

    assert_redirected_to root_path
  end
end
