module Secretary
  class Version < ActiveRecord::Base
    administrate do |admin|
      admin.define_list do |list|
        list.column "user"
        list.column "description"
        list.column "versioned", header: "Object", linked: true
        list.column "version_number"
      end
    end
    
    belongs_to  :versioned, polymorphic: true
    belongs_to  :user, class_name: Secretary::Config.user_class
    
    #---------------
    
    validates_presence_of :versioned, :object_yaml
    
    #---------------

    before_create :increment_version_number
    
    #---------------
    
    def increment_version_number
      latest_version = versioned.versions.last
      
      if latest_version.present?
        self.version_number = latest_version.version_number + 1
      else
        self.version_number = 1
      end
    end
    
    #---------------
    
    def self.generate(object)
      self.create(
        versioned:    object,
        user_id:      object.logged_user_id,
        description:  generate_description(object),
        object_yaml:  object.dirty.to_yaml)
    end
    
    #---------------
    
    def self.generate_description(object)
      "Changed #{object.changed_attributes.keys.join(", ")}"
    end
    
    #---------------
    
    def title
      "v#{version_number}"
    end
    
    #---------------

    def object
      @object ||= YAML.load(self.object_yaml)
    end

    #---------------
    
    def revert
      
    end
  end
end
