##
# NprImport
#
# Import a story from NPR
#
module Job
  class NprImport < Base
    @queue = namespace
    
    def self.after_perform(id)
      hook = Outpost::Hook.new(
        :path => "/task/finished/#{@npr_story.obj_key.gsub(/\//, "-")}:import",
        :data => {
          :location => @story ? @story.admin_edit_path : NewsStory.admin_index_path
        })
        
      hook.publish
    end

    #---------------------
    
    def self.perform(id)
      @npr_story = NprStory.find(id)
      @story = @npr_story.import
    end
  end
end
