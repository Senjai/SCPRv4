class SectionCategory < ActiveRecord::Base
  # Join Model
  belongs_to :section
  belongs_to :category
end
