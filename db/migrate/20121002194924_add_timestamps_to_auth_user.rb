class AddTimestampsToAuthUser < ActiveRecord::Migration
  def change
    add_column "auth_user", "created_at", :datetime
    add_column "auth_user", "updated_at", :datetime
    AdminUser.all.each do |u|
      u.update_attribute(:updated_at, Time.now)
      u.update_attribute(:created_at, u.date_joined)
    end
  end
end
