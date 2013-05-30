module RemoteArticleAdapters
  # National Public Radio
  class NPR
    # An array of elements in an NPR::Story's 
    # +fullText+ attribute that we want to 
    # strip out before importing.
    UNWANTED_CSS = [
      '.storytitle',
      '#story-meta',
      '.bucketwrap',
      '#primaryaudio',
      'object'
    ]
    
    UNWANTED_ATTRIBUTES = [
      'class',
      'id',
      'data-metrics'
    ]

    # NPR IDs we're importing:
    # Reference: http://www.npr.org/api/inputReference.php  
    IMPORT_IDS = [
      '1001',      # News (topic)
      '93559255',  # Planet Money (blog)
      '93568166',  # Monkey See (blog)
      '15709577',  # All Songs Considered (blog)
      '173754155'  # Code Switch (blog)
    ]
  
    class << self
      def sync
        # The "id" parameter in this case is actually referencing a list.
        # Stories from the last hour are returned... be sure to run this script
        # more often than that!
        stories = NPR::Story.where(
            :id     => IMPORT_IDS,
            :date   => (1.hour.ago..Time.now))
          .set(
            :requiredAssets   => 'text',
            :action           => "or")
          .order("date descending").limit(20).to_a
        
        log "#{stories.size} stories found from the past hour (max 20)"
        
        added = []
        stories.each do |story|
          # Check if this story was already cached - if not, cache it.
          if NprStory.find_by_npr_id(story.id)
            log "NPR Story ##{story.id} already cached"
          else
            npr_story = NprStory.new(
              :npr_id       => story.id, 
              :headline     => story.title, 
              :teaser       => story.teaser,
              :published_at => story.pubDate,
              :link         => story.link_for("html"),
              :new          => true
            )
            
            if npr_story.save
              added.push npr_story
              log "Saved NPR Story ##{story.id} as NprStory ##{npr_story.id}"
            else
              log "Couldn't save NPR Story ##{story.id}"
            end
          end
        end # each
        
        # Return which stories were actually cached
        added
      end
    end
  end
end
