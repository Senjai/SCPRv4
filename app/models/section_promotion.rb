class SectionPromotion < ActiveRecord::Base
  # Join Model
  belongs_to :section
  belongs_to :promotion
end
