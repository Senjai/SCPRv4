##
# Send a breaking news mobile notification
#
module Job
  class SendBreakingNewsMobileNotification < Base
    @queue = "#{namespace}:breaking_news_email"

    class << self
      def perform(id)
        @alert = BreakingNewsAlert.find(id)
        @alert.publish_mobile_notification
      end
    end
  end
end
