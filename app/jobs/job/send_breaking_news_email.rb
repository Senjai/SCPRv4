##
# Send a breaking news alert
#
module Job
  class SendBreakingNewsEmail < Base
    @queue = "#{namespace}:breaking_news_email"

    class << self
      def perform(id)
        @alert = BreakingNewsAlert.find(id)
        @alert.publish_email
      end
    end
  end
end
