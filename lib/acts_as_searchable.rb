##
# ActsAsSearchable
#
# Requires a sphinx index to be defined on the class.
# All it really does is add a callback to enqueue an
# index on that model after a record is saved.
#
module ActsAsSearchable
  extend ActiveSupport::Concern
  
  module ClassMethods
    def acts_as_searchable
      include InstanceMethods
      after_save :enqueue_index
    end
  end
  
  #-----------------
  
  module InstanceMethods
    def enqueue_index
      indexer = Indexer.new(self.class)
      indexer.enqueue
    end
  end
end

ActiveRecord::Base.send :include, ActsAsSearchable
