module Secretary
  class Version < ActiveRecord::Base
    serialize :object_changes

    IGNORE = ["id", "created_at", "updated_at", "password_digest"]

    belongs_to  :versioned, polymorphic: true
    belongs_to  :user, class_name: Secretary.config.user_class

    #---------------

    validates_presence_of :versioned

    #---------------

    before_create :increment_version_number

    #---------------



    class << self
      def should_ignore?(key)
        IGNORE.include? key
      end

      #---------------
      # Builds a new version for the passed-in object
      # Passed-in object is a dirty object (not yet saved)
      # Version will be saved when the object is saved
      def generate(object)
        object.versions.create(
          :user_id          => object.logged_user_id,
          :description      => generate_description(object),
          :object_changes   => object.changes
        )
      end


      private

      def generate_description(object)
        case object.action
        when :create
          "Created #{object.simple_title}"
        when :update
          attributes = object.changes.keys
          attributes.delete_if { |key| Version.should_ignore?(key) }
          "Changed #{attributes.to_sentence}"
        else
          "Generated Version"
        end
      end
    end


    def attribute_diffs
      @attribute_diffs ||= begin
        changes           = self.object_changes.dup
        attribute_diffs   = {}

        # Drop attributes that we don't want to diff
        changes.delete_if { |key, _| Version.should_ignore?(key) }

        # Compare each of object_b's attributes to object_a's attributes
        # And if there is a difference, add it to the Diff
        changes.each do |attribute, values|
          # values is [previous_value, new_value]
          diff = Diffy::Diff.new(values[0].to_s, values[1].to_s)

          if diff.string1 != diff.string2
            attribute_diffs[attribute] = diff
          end
        end

        attribute_diffs
      end
    end

    #---------------

    def title
      "#{versioned.simple_title} v#{version_number}"
    end

    #---------------
    # Find other versions for this object
    # Do not include this version
    def siblings
      @siblings ||= versioned.versions.order("version_number desc").where("version_number != ?", self.version_number)
    end

    #---------------
    # Look for the closest version below the current one
    def previous_version
      @previous_version ||= self.siblings.where("version_number < ?", self.version_number).first
    end


    private

    def increment_version_number
      latest_version = versioned.versions.order("version_number").last
      self.version_number = latest_version.try(:version_number).to_i + 1
    end
  end
end
