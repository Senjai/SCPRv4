##
# Job::BreakingNewsEmail
#
# Enqueue a breaking news e-mail alert
#
module Job
  class BreakingNewsEmail < Base
    @queue = "#{namespace}:breaking_news_email"

    #---------------------

    def self.perform(id)
      @alert = BreakingNewsAlert.find(id)
      @alert.publish_email
    end
  end
end
