##
# BylinesAssociation
#
# Defines bylines association
# 
module Concern
  module Associations
    module BylinesAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :bylines, as: :content, class_name: "ContentByline",  dependent: :destroy
      end
      
      #-------------------
      
      def byline_elements
        ["KPCC"]
      end

      #-------------------
      
      def sorted_bylines
        authors = [ [],[],[] ]

        # 1) break bylines up by role
        self.bylines.each { |b| authors[b.role] << b }

        [0,1,2].each do |i|
          if !authors[i].any?
            next
          end

          # 2) now sort each list by last name, first name
          authors[i] = authors[i].sort { |a,b| 
            aN = (a.user ? a.user.name : a.name).split(' ').reverse.join('')
            bN = (b.user ? b.user.name : b.name).split(' ').reverse.join('')

            aN <=> bN
          }
        end

        return authors
      end
    end # BylinesAssociation
  end # Associations
end # Concern
