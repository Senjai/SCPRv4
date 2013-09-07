module Secretary
  module TracksAssociation
    # Track the associations passed-in
    # This will make sure that when you change the association,
    # the saved record will get a new version, with association
    # diffs and everything.
    #
    # Example:
    #
    #   has_secretary
    #
    #   has_many :bylines,
    #     :as               => :content,
    #     :class_name       => "ContentByline",
    #     :dependent        => :destroy,
    #   tracks_association :bylines
    #
    # Forcing the changes into the custom_changes has allows us
    # to keep track of dirty associations, so that checking stuff
    # like `changed?` will work.
    def tracks_association(*associations)
      include InstanceMethodsOnActivation

      associations.each do |name|
        module_eval <<-EOE, __FILE__, __LINE__ + 1
          attr_writer :#{name}_were
          def #{name}_were
            @#{name}_were ||= association_was("#{name}")
          end


          private 

          def build_custom_changes_for_#{name}
            return if !self.class.has_secretary?
            build_custom_changes_for_association("#{name}")
            @#{name}_were = nil
          end


          def mark_#{name}_as_changed(object)
            mark_association_as_changed("#{name}", object)
          end


          def clear_dirty_#{name}
            clear_dirty_association(name)
          end
        EOE

        before_save :"build_custom_changes_for_#{name}"
        after_commit :"clear_dirty_#{name}"

        send("before_add_for_#{name}=", Array(:"#{name}_were"))
        send("before_remove_for_#{name}=", Array(:"#{name}_were"))
        send("after_add_for_#{name}=", Array(:"mark_#{name}_as_changed"))
        send("after_remove_for_#{name}=", Array(:"mark_#{name}_as_changed"))
      end
    end


    module InstanceMethodsOnActivation
      private

      def association_was(name)
        persisted? ? self.class.find(self.id).send(name).to_a : []
      end

      def mark_association_as_changed(name, object)
        return if !self.class.has_secretary? ||
        send("should_reject_#{name}?", object.attributes.stringify_keys)

        self.custom_changes[name] = [send("#{name}_were"), send(name)]
      end

      def clear_dirty_association(name)
        self.send("#{name}_were=", nil)
      end
    end
  end
end
