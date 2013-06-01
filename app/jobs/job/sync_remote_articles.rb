##
# SyncRemoteArticles
#
# Sync with the Remote Article API's
#
module Job
  class SyncRemoteArticles < Base
    @queue = namespace
    
    def self.after_perform
      hook = Outpost::Hook.new(
        :path => "/task/finished/remote_articles:sync",
        :data => {
          :location => RemoteArticle.admin_index_path
        })
        
      hook.publish
    end

    #---------------------
    
    def self.perform
      RemoteArticle.sync
      self.log "Synced Remote Articles."
    end
  end
end
