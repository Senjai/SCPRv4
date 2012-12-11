class RemoveDuplicatePermissions < ActiveRecord::Migration
  def up
    exists = {}
    Permission.all.each do |p|
      if exists[p.resource]
        p.destroy
      else
        exists[p.resource] = true
      end
    end
  end

  def down
  end
end
