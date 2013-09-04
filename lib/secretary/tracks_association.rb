module Secretary
  module TracksAssociation
    # Track the associations passed-in
    # This will make sure that when you change the association,
    # the saved record will get a new version, with association
    # diffs and everything.
    #
    # YOU MUST add `before_add` and `before_remove` callbacks to
    # the has_many macro for the association, which both reference
    # the same method, `get_original_#{association_name}`. Here
    # is a complete example:
    #
    # has_secretary
    #
    # has_many :bylines,
    #   :as               => :content,
    #   :class_name       => "ContentByline",
    #   :dependent        => :destroy,
    #   :before_add       => :get_original_bylines,
    #   :before_remove    => :get_original_bylines
    #
    # tracks_association :bylines
    def tracks_association(*associations)
      associations.each do |name|
        module_eval <<-EOE, __FILE__, __LINE__ + 1
          private 

          def build_custom_changes_for_#{name}
            return if !self.class.has_secretary?

            build_custom_changes_for_association("#{name}", @#{name}_were)
            @#{name}_were = nil
          end

          def get_original_#{name}(_)
            return if !self.class.has_secretary?

            @#{name}_were ||= persisted? ? self.class.find(self.id).#{name}.to_a : []
          end

          def force_#{name}_into_changes(_)
            return if !self.class.has_secretary?

            self.custom_changes["#{name}"] = [Array(@#{name}_were), self.#{name}]
          end
        EOE

        before_save :"build_custom_changes_for_#{name}"
      end
    end
  end
end
