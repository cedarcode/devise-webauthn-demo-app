require "test_helper"

class ApplicationControllerTestCase < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    # TODO Remove when Devise fixes https://github.com/heartcombo/devise/issues/5705
    Rails.application.reload_routes_unless_loaded
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
end
