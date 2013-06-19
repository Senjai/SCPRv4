class VideoShell < ActiveRecord::Base
  self.table_name = "contentbase_videoshell"
end

class RemoveVideoshellsAssociations < ActiveRecord::Migration
  def up
    deleted = 0


    [ 
      ContentAsset, 
      ContentByline, 
      FeaturedComment, 
      MissedItContent, 
      HomepageContent,
      Related,
      RelatedLink
    ].each do |klass|
      records = klass.where(content_type: "VideoShell")
      records.destroy_all
      deleted += records.size
    end

    related = Related.where(related_type: "VideoShell")
    related.destroy_all
    deleted += related.size


    p = Permission.where(resource: "VideoShell").first
    UserPermission.where(permission_id: p.id).delete_all
    p.delete

    puts "deleted #{deleted.size} records"
  end

  def down
  end
end
