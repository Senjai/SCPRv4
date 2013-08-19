module Secretary
  module HasSecretary
    #---------------------
    # has_secretary?
    # See if a class is versioned
    def has_secretary?
      !!@_has_secretary
    end

    #---------------------
    # has_secretary
    # Apply to any class that should be versioned
    def has_secretary(options={})
      @_has_secretary = true

      has_many :versions,
        :class_name   => "Secretary::Version",
        :as           => :versioned,
        :dependent    => :destroy

      attr_accessor :logged_user_id, :action

      before_create :set_create
      before_update :set_update
      after_save    :generate_version, if: -> { self.changes.present? }
      after_save    :clean_action

      send :include, InstanceMethods
    end

    #---------------------

    module InstanceMethods
      def generate_version
        Version.generate(self)
      end

      # Use Rails built-in Dirty attributions to get
      # the easy ones. By the time we're generating
      # this version, this hash could already
      # exist with some custom changes, such as
      # assets or content.
      def changes
        self.custom_changes.reverse_merge super
      end

      def changed?
        super || custom_changes.present?
      end

      #-----------
      # Similar to ActiveModel::Dirty#changes, but lets us
      # pass in some custom changes (such as associations)
      # which wouldn't be picked up by the built-in method.
      #
      # This method should only be used for adding custom changes
      # to the changes hash. For storing and comparing and whatnot,
      # use #changes as usual.
      #
      # This method basically exists just to get around the behavior
      # of #changes (since it sends the attribute message to the
      # object, which we don't always want, for associations for
      # example).
      def custom_changes
        @custom_changes ||= HashWithIndifferentAccess.new
      end

      #-----------

      def set_create
        self.action = :create
      end

      def set_update
        self.action = :update
      end

      #-----------

      def clean_action
        @action = nil
      end
    end
  end
end
