class NullifyPublishedAtFields < ActiveRecord::Migration
  def up
    [NewsStory, BlogEntry, ShowSegment, ShowEpisode, VideoShell, ContentShell, Homepage].each do |klass|
      klass.update_all('published_at = null', "status != 5 and published_at is not null")
    end
  end

  def down
  end
end
