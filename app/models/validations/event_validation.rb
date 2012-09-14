module Validations
  module EventValidation
    include SlugValidation
    
    included do
      validates :slug, uniqueness: { scope: :starts_at, message: "has already been used for that start date." }
      validates_presence_of :headline, :etype, :starts_at
    end
  end
end
