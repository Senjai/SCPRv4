class SectionBlog < ActiveRecord::Base
  # Join Model
  belongs_to :section
  belongs_to :blog
end
