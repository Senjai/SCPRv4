##
# RelatedContentAssociation
#
# Defines forward and backwards relations
# 
module Concern
  module Associations
    module RelatedContentAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :brels, as: :content, class_name: "Related", dependent: :destroy
        has_many :frels, as: :related, class_name: "Related", dependent: :destroy
      end
      
      #-------------------------
      # Takes one or more finders for relations and returns one list 
      # sorted by published_at desc and with duplicates removed
      # TODO: Rewrite this method
      def sorted_relations(*lists)
        content = []
        lists.each do |finder|
          # push whichever piece of content isn't us onto the content array
          content << finder.all.collect { |rel| rel.content == self ? rel.related : rel.content }
        end

        # flatten and remove duplicates
        content = content.flatten.compact.uniq

        # sort the list and return it
        return content.sort_by { |c| c.published_at }.reverse
      end
    end # RelatedContentAssociation
  end # Associations
end # Concern
