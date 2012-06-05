class AddEncryptedPasswordToAdminUsers < ActiveRecord::Migration
  def change
    add_column :auth_user, :password_digest, :string
    add_column :auth_user, :auth_token, :string
    add_column :auth_user, :created_at, :datetime
    add_column :auth_user, :name, :string
    
    AdminUser.all.each do |user|
      name = [user.first_name, user.last_name].join(" ")
      user.update_attribute(:created_at, user.date_joined)
      user.update_attribute(:name, name.present? ? name : "Anonymous")
    end
  end
end
