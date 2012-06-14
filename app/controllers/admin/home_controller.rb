class Admin::HomeController < Admin::BaseController
  def index
    @admin_models = [NewsStory, BlogEntry, Blog, ContentShell, VideoShell, Homepage, Tag, Flatpage, KpccProgram, OtherProgram, ShowEpisode, ShowSegment]
  end
end
