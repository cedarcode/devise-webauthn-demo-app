# frozen_string_literal: true

class Users::PasskeysController < Devise::PasskeysController
  private

  def after_update_path
    root_path
  end
end
