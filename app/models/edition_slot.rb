# Join model between an Edition and one of its 'Items'.
# An "Item" is just an object that can be represented 
# as an Abstract.
#
# Yes, I know this a terribly-named class.
class EditionSlot < ActiveRecord::Base
  belongs_to :edition, touch: true
  belongs_to :item, polymorphic: true

  # We can't use the one from outpost-aggregator right now,
  # because it assumes that the association is called "content".
  def simple_json
    @simple_json ||= {
      "id"          => self.item.try(:obj_key),
      "position"    => self.position.to_i
    }
  end
end
