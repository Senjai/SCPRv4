module ActiveModel
  module SecureAttribute
    extend ActiveSupport::Concern
    module ClassMethods
      
      # Based on Rails' has_secure_password. More flexible, allowing you to encrypt any attribute into any column.
      def has_secure_attribute(attribute_name, options = {})
        gem 'bcrypt-ruby', '~> 3.0.0'
        require 'bcrypt'

        cattr_accessor :encrypted_attribute, :attribute
        self.attribute = attribute_name.to_sym
        self.encrypted_attribute = options.fetch(:encrypted_attribute, "#{attribute_name}_digest").to_sym

        attr_reader attribute

        if options.fetch(:validations, true)
          validates_confirmation_of attribute
          validates_presence_of     attribute, :on => :create
        end

        before_create { raise "#{encrypted_attribute.to_s.gsub("_", " ").capitalize} missing on new record" if send(encrypted_attribute).blank? }

        extend ClassMethodsOnActivation
        include InstanceMethodsOnActivation

        attribute_writer_method(attribute)

        if respond_to?(:attributes_protected_by_default)
          def self.attributes_protected_by_default
            super + [send(:encrypted_attribute).to_s]
          end
        end
      end
    end

    module ClassMethodsOnActivation
      private
        def attribute_writer_method(name)
          define_method("#{name}=") do |unencrypted_attribute|
            unless unencrypted_attribute.blank?
              instance_variable_set("@#{self.class.attribute}", unencrypted_attribute)
              send("#{self.class.encrypted_attribute}=", BCrypt::Password.create(unencrypted_attribute))
            end
          end
        end
    end

    module InstanceMethodsOnActivation
      def authenticate(unencrypted_attribute)
        BCrypt::Password.new(send(self.class.encrypted_attribute)) == unencrypted_attribute && self
      end
    end
  end
end
