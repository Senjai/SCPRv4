module Validations
  module SlugUniqueForPublishedAtValidation
    extend ActiveSupport::Concern

    include Validations::SlugValidation
    included do
      validates :slug,
        uniqueness: { scope: :published_at, message: "has already been used for that publish date." }
      #
    end
  end
end
