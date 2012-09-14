module Validations
  extend ActiveSupport::Concern
  
  # Define some defaults
  DEFAULTS = {
    slug_format: %r{[\w-]+}
  }
end

module ActiveRecord
  class Base
    if File.exists?("#{Rails.root}/app/models/validations/#{self.model_name.underscore}_validation.rb")
      include "Validations::#{self.model_name}Validation".constantize
    end
  end
end
