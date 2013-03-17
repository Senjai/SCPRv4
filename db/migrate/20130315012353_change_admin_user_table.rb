class ChangeAdminUserTable < ActiveRecord::Migration
  def up
    rename_column :auth_user, :password, :old_password
    rename_column :auth_user, :is_staff, :can_login

    add_index :auth_user, [:username, :can_login]
    remove_index :auth_user, name: "username"

    add_column :auth_user, :password_digest, :string
    add_column :auth_user, :name, :string

    change_column :auth_user, :email, :string, null: true
    change_column :auth_user, :username, :string, null: true
    change_column :auth_user, :last_login, :datetime, null: true
    change_column :auth_user, :old_password, :string, null: true
    
    AdminUser.all.each do |user|
      if user.first_name.blank? && user.last_name.blank?
        user.name = "KPCC Employee"
      else
        user.name = [user.first_name, user.last_name].select { |n| n.present? }.join(" ")
      end

      user.created_at = user.date_joined
      user.save!
    end

    remove_column :auth_user, :first_name
    remove_column :auth_user, :last_name
    remove_column :auth_user, :date_joined
    remove_column :auth_user, :is_active
  end

  def down
    rename_column :auth_user, :old_password, :password
    rename_column :auth_user, :can_login, :is_staff

    remove_index :auth_user, column: [:username, :can_login]
    add_index :auth_user, :username, name: "username"

    remove_column :auth_user, :password_digest
    remove_column :auth_user, :name

    add_column :auth_user, :first_name, :string
    add_column :auth_user, :last_name, :string
    add_column :auth_user, :date_joined, :datetime
    add_column :auth_user, :is_active, :boolean, default: false

    AdminUser.all.each do |user|
      names = user.name.split
      user.first_name = names.first
      user.last_name  = names.last
      user.date_joined = user.created_at
      user.save!
    end
  end
end
