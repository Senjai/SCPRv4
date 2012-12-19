##
# NprImport
#
# Import a story from NPR
#
module Job
  class NprImport < Base
    @queue = namespace
    
    def self.after_perform(id, username)
      hook = AdminResource::Hook.new(action: "finished-task", user: username)
      hook.publish
    end

    #---------------------
    
    def self.perform(id, username)
      npr_story = NprStory.find(id)
      npr_story.import
    end
  end
end
