module MultiAmerican
  class ResqueJob
    @queue = Rails.application.config.scpr.resque_queue
  
    class << self
      def logger
        @@logger ||= Logger.new(File.join Rails.root, "log", "resque.log")
      end
      
      def log(msg)
        logger.info "*** [#{Time.now}] #{msg}"
      end
      
      def log_error(obj, action, e)
        @errors ||= 0
        @errors += 1
        log "Error on #{action} of #{obj.class.name} ##{obj.id}! \n#{e.message} \n#{e.backtrace.inspect}\n\n"
      end
      
      def log_success(obj, action)
        @successes ||= 0
        @successes += 1
        log "Successful #{action} of #{obj.class.name} ##{obj.id}"
      end
      
      #------------------------
      
      def finished_cache_key
        [MultiAmerican.cache_namespace, "finished_queue"].join(":")
      end
      
      def after_perform(resource_class, document_path, action, id, username)
        log "Performed #{action} for #{@queue}, sending to #{username}"
        MultiAmerican.rcache.set finished_cache_key, "1"
        NodePusher.publish("finished_queue", username, { job: action, wp_id: id, resource_class: resource_class, errors: @errors.to_i, successes: @successes.to_i } )
      end

      def perform(resource_class, document_path, action, id, username)
        if (@objects = resource_class.constantize.cached).empty?
          doc = MultiAmerican::Document.new(document_path)
          @objects = resource_class.constantize.find(doc)
        end
      
        # If we're given an id, only import/deport that one
        if id
          if obj = @objects.find { |r| r.id == id.to_i }
            begin
              if obj.send action
                log_success(obj, action)
              end
            rescue Exception => e
              log_error(obj, action, e)
              return false
            end
          else
            return false
          end
        else
          # Otherwise import/remove all of them
          @objects.each do |obj|
            begin
              if obj.send action
                log_success(obj, action)
              end
            rescue Exception => e
              # Whoops...
              log_error(obj, action, e)
              next
            end
          end
          return true
        end
      end
    end
  end
end