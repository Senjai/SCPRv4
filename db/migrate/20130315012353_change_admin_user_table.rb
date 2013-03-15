class ChangeAdminUserTable < ActiveRecord::Migration
  def up
    rename_table :auth_user, :admin_users

    rename_column :admin_users, :password, :old_password
    rename_column :admin_users, :is_staff, :can_login

    add_column :admin_users, :password_digest, :string
    add_column :admin_users, :name, :string

    change_column :admin_users, :email, :string, null: true

    AdminUser.all.each do |user|
      user.name = "#{user.first_name} #{user.last_name}"
      user.created_at = user.date_joined
      user.save!
    end

    remove_column :admin_users, :first_name
    remove_column :admin_users, :last_name
    remove_column :admin_users, :date_joined
    remove_column :admin_users, :is_active
  end

  def down
    rename_column :admin_users, :old_password, :password
    rename_column :admin_users, :can_login, :is_staff

    remove_column :admin_users, :password_digest
    remove_column :admin_users, :name

    add_column :admin_users, :first_name, :string
    add_column :admin_users, :last_name, :string
    add_column :admin_users, :date_joined, :datetime
    add_column :admin_users, :is_active, :boolean, default: false

    AdminUser.all.each do |user|
      names = user.name.split
      user.first_name = names.first
      user.last_name  = names.last
      user.date_joined = user.created_at
      user.save!
    end

    rename_table :admin_users, :auth_user
  end
end
