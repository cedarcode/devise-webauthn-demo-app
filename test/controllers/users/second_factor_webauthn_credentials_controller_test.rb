require "application_controller_test_case"

class Users::SecondFactorWebauthnCredentialsControllerTest < ApplicationControllerTestCase
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

  test "should create security key with valid credential" do
    sign_in @user

    # First, get the new page to set up a challenge
    get :new
    challenge = session[:webauthn_challenge]

    # Create a fake WebAuthn credential
    client = WebAuthn::FakeClient.new(
      WebAuthn.configuration.allowed_origins.first,
      encoding: :base64url
    )
    # Security keys don't require user verification, just user presence
    credential = client.create(
      challenge: challenge,
      user_verified: false,
      user_present: true
    )

    assert_difference("@user.webauthn_credentials.count", 1) do
      post :create, params: {
        name: "My Security Key",
        public_key_credential: credential.to_json
      }
    end

    assert_redirected_to root_path
    assert_equal "Security Key created successfully.", flash[:notice]
    assert_nil session[:webauthn_challenge]
  end

  test "should not create security key without user presence" do
    sign_in @user

    # Get challenge
    get :new
    challenge = session[:webauthn_challenge]

    # Create credential without user presence (invalid)
    client = WebAuthn::FakeClient.new(
      WebAuthn.configuration.allowed_origins.first,
      encoding: :base64url
    )
    credential = client.create(
      challenge: challenge,
      user_verified: false,
      user_present: false
    )

    assert_no_difference("@user.webauthn_credentials.count") do
      post :create, params: {
        name: "Invalid Security Key",
        public_key_credential: credential.to_json
      }
    end

    assert_redirected_to root_path
  end

  test "should destroy security key" do
    sign_in @user
    security_key = @user.webauthn_credentials.create!(
      external_id: "test-security-key-id",
      public_key: "test-public-key",
      name: "Test Security Key",
      sign_count: 0,
      authentication_factor: :second_factor
    )

    assert_difference("@user.webauthn_credentials.count", -1) do
      delete :destroy, params: { id: security_key.id }
    end

    assert_redirected_to root_path
  end
end
