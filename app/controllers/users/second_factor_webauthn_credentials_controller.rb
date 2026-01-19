# frozen_string_literal: true

class Users::SecondFactorWebauthnCredentialsController < Devise::SecondFactorWebauthnCredentialsController
  private

  def after_create_path
    root_path
  end

  def after_destroy_path
    root_path
  end
end
