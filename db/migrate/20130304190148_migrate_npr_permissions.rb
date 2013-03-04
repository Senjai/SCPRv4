module Django
  #--------------------------
  # User
  class User < ActiveRecord::Base
    self.table_name = "auth_user"
    
    has_many :django_user_permissions, class_name: "Django::UserPermission"
    has_many :django_user_groups, class_name: "Django::UserGroup"
    has_many :permissions, through: :django_user_permissions
    has_many :groups, through: :django_user_groups
  end

  #--------------------------
  # Group  
  class Group < ActiveRecord::Base
    self.table_name = "auth_group"
    
    has_many :django_group_permissions, class_name: "Django::GroupPermission"
    has_many :django_user_groups, class_name: "Django::UserGroup"
    has_many :permissions, through: :django_group_permissions
    has_many :users, through: :django_user_groups
  end

  #--------------------------
  # Permission
  class Permission < ActiveRecord::Base
    self.table_name = "auth_permission"
    
    has_many :django_user_permissions, class_name: "Django::UserPermission"
    has_many :django_group_permissions, class_name: "Django::GroupPermission"
    has_many :users, through: :django_user_permissions
    has_many :groups, through: :django_group_permissions
    
    MAP = {
      "otherprogram"          => OtherProgram,
      "story"                 => NewsStory,
      "kpccprogram"           => KpccProgram,
      "episode"               => ShowEpisode,
      "segment"               => ShowSegment,
      "entry"                 => BlogEntry,
      "release"               => PressRelease,
      "query"                 => PijQuery,
      "contentshell"          => ContentShell,
      "featuredcommentbucket" => FeaturedCommentBucket,
      "featuredcomment"       => FeaturedComment,
      "misseditbucket"        => MissedItBucket,
      "videoshell"            => VideoShell,
      "breakingnewsalert"     => BreakingNewsAlert
    }
  
    def railify
      pieces = self.codename.split("_")
      pieces.shift
      key = pieces.join("_")
    
      klass = key.classify.safe_constantize || MAP[key]
      klass ? klass.to_s : nil
    end
  end

  #--------------------------
  # User <-> Group
  class UserGroup < ActiveRecord::Base
    self.table_name = "auth_user_groups"
    belongs_to :group, class_name: "Django::Group"
    belongs_to :user, class_name: "Django::User"
  end

  #--------------------------
  # User <-> Permission
  class UserPermission < ActiveRecord::Base
    self.table_name = "auth_user_user_permissions"
    belongs_to :permission, class_name: "Django::Permission"
    belongs_to :user, class_name: "Django::User"
  end

  #--------------------------
  # Group <-> Permission
  class GroupPermission < ActiveRecord::Base
    self.table_name = "auth_group_permissions"
    belongs_to :permission, class_name: "Django::Permission"
    belongs_to :group, class_name: "Django::Group"
  end
end

#--------------------------


class MigrateNprPermissions < ActiveRecord::Migration
  def up
    @npr_permission = Permission.find_by_resource("NprStory")
    dp = Django::Permission.find(252) # Django NPR Change permission

    Django::User.all.each do |du|
      ru = AdminUser.find(du.id)

      if du.permissions.include? dp
        add_npr_permission(ru)
      end 

      du.groups.each do |dg|
        if dg.permissions.include? dp
          add_npr_permission(ru)
        end
      end

      ru.save!
    end
  end
  
  def down
  end
  
  private
  
  def add_npr_permission(ru)
    if !ru.permissions.include?(@npr_permission)
      ru.permissions << @npr_permission
    end
  end
end
