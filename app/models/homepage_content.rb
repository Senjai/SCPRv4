class HomepageContent < ActiveRecord::Base
  include Outpost::Aggregator::SimpleJson

  self.table_name =  "layout_homepagecontent"

  belongs_to :content, polymorphic: true, conditions: { status: ContentBase::STATUS_LIVE }
  belongs_to :homepage
end
