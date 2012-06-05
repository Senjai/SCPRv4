class ChangePasswordColumnName < ActiveRecord::Migration
  def change
    rename_column :auth_user, :password, :encrypted_password
  end
end
