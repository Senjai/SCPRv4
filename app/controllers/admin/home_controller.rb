class Admin::HomeController < Admin::BaseController
  def index
    # NewsStory, BlogEntry, Blog, ContentShell, VideoShell, Homepage, Tag, Flatpage, KpccProgram, OtherProgram, PijQuery, ShowEpisode, ShowSegment
    @admin_models = [Section, Promotion, Blog]
    @extra_links = [
      { title: "Multi-American Import", path: admin_multi_american_path, info: "Landing page for managing the Multi-American import" }
    ]
  end
end
