class RemoveNullEditionSlots < ActiveRecord::Migration
  def up
    EditionSlot.where(edition_id: nil).destroy_all
  end

  def down
    #no
  end
end
