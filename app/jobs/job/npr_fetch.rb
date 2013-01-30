##
# NprFetch
#
# Sync with the NPR API
#
module Job
  class NprFetch < Base
    @queue = namespace
    
    def self.after_perform
      hook = AdminResource::Hook.new(
        :path => "/task/finished/npr_stories:sync",
        :data => {
          :location => NprStory.admin_index_path
        })
        
      hook.publish
    end

    #---------------------
    
    def self.perform
      NprStory.sync_with_api
    end
  end
end
