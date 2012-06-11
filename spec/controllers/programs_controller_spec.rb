require "spec_helper"

describe ProgramsController do
  describe "GET /archive" do
    it "finds the episode for the program on the given date" do
      episode = create :show_episode, air_date: Chronic.parse("March 22, 2012")
      get :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
      assigns(:episode).should eq episode
    end
    
    it "assigns @date if date is given" do
      episode = create :show_episode, air_date: Chronic.parse("March 22, 2012")
      get :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
      date = assigns(:date)
      date.should be_a Time
      date.beginning_of_day.should eq episode.air_date.beginning_of_day
    end
    
    it "doesn't assign @episode if no date is given" do
      episode = create :show_episode
      get :archive, show: episode.show.slug
      assigns(:episode).should be_nil
    end
  end
  
  describe "GET /show" do
    describe "with XML" do
      it "renders xml template when requested" do
        program = create :kpcc_program
        get :show, show: program, format: :xml
        response.should render_template 'programs/show'
      end
    end
  end
end