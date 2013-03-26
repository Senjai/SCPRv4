class Related < ActiveRecord::Base
  self.table_name =  'media_related'

  belongs_to :content, polymorphic: true
  belongs_to :related, polymorphic: true, conditions: { status: ContentBase::STATUS_LIVE }

  def simple_json
    {
      "id"       => self.related.try(:obj_key), # TODO Store this in join table
      "position" => self.position.to_i
    }
  end
end
