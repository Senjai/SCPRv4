# A collection of items, which are meant to be represented
# as Abstracts (although not all of them will actually be 
# an Abstract object).
#
# This model was created originally for the mobile application,
# but there's no reason it couldn't also be presented on the 
# website if there was a place out for it.
class Edition < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Associations::ContentAlarmAssociation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::TouchCallback


  STATUS_DRAFT    = 0
  STATUS_PENDING  = 3
  STATUS_LIVE     = 5

  STATUS_TEXT = {
    STATUS_DRAFT      => "Draft",
    STATUS_PENDING    => "Pending",
    STATUS_LIVE       => "Live"
  }


  has_many :slots, class_name: "EditionSlot", order: "position"
  accepts_json_input_for :slots

  # We don't want to use ContentBase::STATUS_LIVE, so just manually define
  # this scope here (as opposed to using the PublishScope module).
  scope :published, -> {
    where(status: STATUS_LIVE)
    .order("published_at desc")
  }


  validates :status, presence: true


  class << self
    def status_text_collection
      STATUS_TEXT.map { |k,v| [v, k] }
    end
  end

  # Returns an array of Abstract objects
  # by mapping all of the items to Abstract objects.
  def abstracts
    @abstracts ||= self.slots.includes(:item).map { |slot|
      slot.item.to_abstract
    }
  end

  def articles
    @articles ||= self.slots.includes(:item).map { |slot|
      slot.item.to_article
    }
  end


  # Determine whether this edition is published.
  def published?
    self.status == STATUS_LIVE
  end

  # Determine whether this edition is pending.
  # Necessary for ContentAlarms.
  def pending?
    self.status == STATUS_PENDING
  end

  def publish
    self.update_attribute(:status, STATUS_LIVE)
  end

  # Return the descriptive status text for this edition.
  def status_text
    STATUS_TEXT[self.status]
  end


  private
  
  def build_slot_association(slot_hash, item)
    if item.published?
      EditionSlot.new(
        :position   => slot_hash["position"].to_i,
        :item       => item,
        :edition    => self
      )
    end
  end
end
