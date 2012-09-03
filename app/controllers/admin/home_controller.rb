class Admin::HomeController < Admin::BaseController
  def index
    @admin_models = [ Section, Promotion, 
                      Blog, BlogEntry, Tag, 
                      NewsStory, 
                      ContentShell, VideoShell, 
                      Homepage, Flatpage, 
                      KpccProgram, OtherProgram, ShowEpisode, ShowSegment, 
                      PijQuery ]
    @extra_links = [
      { title: "Multi-American Import", path: admin_multi_american_path, info: "Landing page for managing the Multi-American import" }
    ]
  end
end
