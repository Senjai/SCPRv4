##
# ImportRemoteArticle
#
# Import a remote article
#
module Job
  class ImportRemoteArticle < Base
    @queue = namespace
    
    def self.after_perform(id, import_to_class)
      hook = Outpost::Hook.new(
        :path => "/task/finished/#{@remote_article.obj_key.gsub(/\//, "-")}:import",
        :data => {
          :location => @story ? @story.admin_edit_path : RemoteArticle.admin_index_path
        })
        
      hook.publish
    end

    #---------------------
    
    def self.perform(id, import_to_class)
      @remote_article = RemoteArticle.find(id)
      @story = @remote_article.import(import_to_class: import_to_class)
    end
  end
end
