module Validations
  module ContentValidation
    extend ActiveSupport::Concern

    included do
      validates_presence_of :headline, :body, :status
    end
  end
end
