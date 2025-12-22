# frozen_string_literal: true

class Users::SecondFactorWebauthnCredentialsController < Devise::SecondFactorWebauthnCredentialsController
  private

  def after_update_path
    root_path
  end
end
