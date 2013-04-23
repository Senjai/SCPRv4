##
# NprImport
#
# Import a story from NPR
#
module Job
  class NprImport < Base
    @queue = namespace
    
    def self.after_perform(id, import_to_class)
      hook = Outpost::Hook.new(
        :path => "/task/finished/#{@npr_story.obj_key.gsub(/\//, "-")}:import",
        :data => {
          :location => @story ? @story.admin_edit_path : NprStory.admin_index_path
        })
        
      hook.publish
    end

    #---------------------
    
    def self.perform(id, import_to_class)
      @npr_story = NprStory.find(id)
      @story = @npr_story.import(import_to_class: import_to_class)
    end
  end
end
