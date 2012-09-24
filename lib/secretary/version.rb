module Secretary
  class Version < ActiveRecord::Base    
    belongs_to  :versioned, polymorphic: true
    belongs_to  :user, class_name: Secretary.config.user_class
    
    #---------------
    
    validates_presence_of :versioned, :object_yaml
    
    #---------------

    before_create :increment_version_number
    
    #---------------
    
    def increment_version_number
      latest_version = versioned.versions.last
      self.version_number = latest_version.try(:version_number).to_i + 1
    end
    
    #---------------
    # Builds a new version for the passed-in object
    # Passed-in object is a dirty object (not yet saved)
    # Version will be saved when the object is saved
    def self.generate(object)
      object.versions.create(
        user_id:      object.logged_user_id,
        description:  generate_description(object),
        object_yaml:  object.to_yaml
      )
    end
    
    #---------------
    
    def self.generate_description(object)
      case object.action
        when :create
          "Created #{object.simple_title}"
        when :update
          attributes = object.changed_attributes.keys
          attributes.delete_if { |key| Diff.should_ignore key }
          "Changed #{attributes.to_sentence}"
        else
          "Generated Version"
        end
      #
    end
    
    #---------------

    def title
      "#{frozen_object.simple_title} v#{version_number}"
    end

    #---------------
    # Find other versions for this object
    # Do not include this version
    def siblings
      @siblings ||= versioned.versions.order("version_number desc").where("version_number != ?", self.version_number)
    end
    
    #---------------

    def frozen_object
      @frozen_object ||= YAML.load(self.object_yaml)
    end
    
    #---------------
    # Look for the closest version below the current one
    def previous_version      
      @previous_version ||= self.siblings.where("version_number < ?", self.version_number).first
    end
  end
end
