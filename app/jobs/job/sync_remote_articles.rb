##
# SyncRemoteArticles
#
# Sync with the Remote Article API's
# This isn't on the "rake_tasks" queue because it
# can be triggered from the CMS.
module Job
  class SyncRemoteArticles < Base
    @queue = "#{namespace}:remote_articles"

    class << self
      def perform
        @synced = RemoteArticle.sync
        self.log "Synced Remote Articles."
      end

      #---------------------

      def after_perform
        hook = Outpost::Hook.new(
          :path => "/task/finished/remote_articles:sync",
          :data => {
            :location         => RemoteArticle.admin_index_path,
            :notifications    => {
              :notice => "Successfully synced <strong>#{@synced.size} stories</strong>."
            }
          }
        )

        timeout_retry(3) do
          hook.publish
        end
      end

      #---------------------

      def on_failure(error)
        hook = Outpost::Hook.new(
          :path => "/task/finished/remote_articles:sync",
          :data => {
            :location         => RemoteArticle.admin_index_path,
            :notifications    => {
              :alert => "There was a problem during the sync. (#{error})"
            }
          }
        )

        timeout_retry(3) do
          hook.publish
        end
      end
    end
  end
end
