##
# NprFetch
#
# Sync with the NPR API
#
module Job
  class NprFetch < Base
    @queue = namespace
    
    def self.after_perform
      hook = Outpost::Hook.new(
        :path => "/task/finished/npr_stories:sync",
        :data => {
          :location => NprStory.admin_index_path
        })
        
      hook.publish
    end

    #---------------------
    
    def self.perform
      added = NprStory.sync_with_api
      self.log "Added #{added.size} stories."
    end
  end
end
