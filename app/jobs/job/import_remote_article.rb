##
# ImportRemoteArticle
#
# Import a remote article
#
module Job
  class ImportRemoteArticle < Base
    @queue = namespace

    #---------------------

    class << self
      def perform(id, import_to_class)
        @remote_article = RemoteArticle.find(id)
        @story = @remote_article.import(import_to_class: import_to_class)
        
        # We want a failure to import to be caught by Resque.
        if !@story
          raise "The API didn't return anything."
        end
      end

      #---------------------

      def after_perform(id, import_to_class)
        hook = Outpost::Hook.new(
          :path => "/task/finished/#{@remote_article.obj_key.gsub(/\//, "-")}:import",
          :data => {
            :location         => @story.admin_edit_path,
            :notifications    => {
              :notice => "Successfully imported #{@remote_article.headline}"
            }
          }
        )
        
        # The current Newsroom server is very slow - retry the hook 
        # a few times so the user will be redirected properly.
        timeout_retry(3) do
          hook.publish
        end
      end

      #---------------------

      def on_failure(error, id, import_to_class)
        hook = Outpost::Hook.new(
          :path => "/task/finished/#{@remote_article.obj_key.gsub(/\//, "-")}:import",
          :data => {
            :location         => RemoteArticle.admin_index_path,
            :notifications    => {
              :alert => "The story could not be imported. (#{error.message})"
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
