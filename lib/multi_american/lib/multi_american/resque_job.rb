module WP
  class ResqueJob
    @queue = Rails.application.config.scpr.resque_queue
  
    class << self
      def after_perform(resource_class, document_path, action, id, username)
        Rails.logger.info "Performed #{action} for #{@queue}, sending to #{username}"
        NodePusher.publish("finished_queue", username, { wp_id: id, resource_class: resource_class } )
      end

      def perform(resource_class, document_path, action, id, username)
        @doc = Rails.cache.fetch(WP::Document.cache_key) || WP::Document.new(document_path)
        @objects = resource_class.constantize.find(@doc)
      
        # If we're given an id, only import/deport that one
        if id
          if obj = @objects.find { |r| r.id == id.to_i }
            return obj.send action
          else
            return false
          end
        else
          # Otherwise import/remove all of them
          @objects.each do |obj|
            obj.send action
          end
          return true
        end
      end
    end
  end
end