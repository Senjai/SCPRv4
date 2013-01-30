##
# NprFetch
#
# Gets latest stories from NPR
#
module CacheTasks  
  class NprFetch < Task
    def run
      comments = self.fetch
      content  = self.parse(comments)
    end

    #--------------
    
    def initialize(forum, interval, api_key, options={})
      @forum    = forum
      @interval = interval
      @api_key  = api_key
    end

    #--------------
    
    def fetch
      # The "id" parameter in this case is actually referencing a list.
      # Stories from the last hour are returned... be sure to run this script
      # more often than that!
      query = NPR::Story.where(id: [1001], date: (1.hour.ago..Time.now)).set(requiredAssets: 'text').order("date descending").limit(20)
      
      query.to_a.each do |story|
        # Check if this story was already cached - if not, cache it.
        unless NprStory.find_by_npr_id(story.id)
          NprStory.new(
            :npr_id   => story.id, 
            :headline => story.title, 
            :teaser   => story.teaser
          )
        end
      end
    end

    #--------------
    
    def parse(response)

    end
  end # MostCommented
end # CacheTasks
