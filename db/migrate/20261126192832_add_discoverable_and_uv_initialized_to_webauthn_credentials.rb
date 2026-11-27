class AddDiscoverableAndUvInitializedToWebauthnCredentials < ActiveRecord::Migration[8.1]
  def change
    add_column :webauthn_credentials, :discoverable, :boolean, null: false, default: false
    add_column :webauthn_credentials, :uv_initialized, :boolean, null: false, default: false
  end
end
