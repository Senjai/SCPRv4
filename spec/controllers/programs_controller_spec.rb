require "spec_helper"

describe ProgramsController do
  render_views
  
  # ----------------------
  
  describe "GET /archive" do
    
    describe "view" do
      render_views
      
      it "renders the view" do
        episode = create :show_episode, air_date: Chronic.parse("March 22, 2012")
        post :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
      end
    end
    
    #-------------------------
    
    describe "controller" do
      it "finds the episode for the program on the given date" do
        episode = create :show_episode, air_date: Chronic.parse("March 22, 2012")
        post :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
        assigns(:episode).should eq episode
      end
    
      it "assigns @date if date is given" do
        episode = create :show_episode, air_date: Chronic.parse("March 22, 2012")
        post :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
        date = assigns(:date)
        date.should be_a Time
        date.beginning_of_day.should eq episode.air_date.beginning_of_day
      end
    end
  end
  
  # ----------------------

  describe "GET /schedule" do
    describe "view" do
      render_views
      
      it "renders the view" do
        create :recurring_schedule_rule
        get :schedule
      end
    end

    #---------------------------
    
    describe "controller" do
      it "assigns @schedule_occurrences to this week's schedule" do
        create :schedule_occurrence, starts_at: Time.now.beginning_of_week
        create :schedule_occurrence, starts_at: Time.now.beginning_of_week + 1.day
        create :schedule_occurrence, starts_at: Time.now.beginning_of_week + 2.days

        get :schedule
        assigns(:schedule_occurrences).should eq ScheduleOccurrence.all
      end
    end
  end

  # ----------------------
   
  describe "GET /index" do
    describe "view" do
      render_views
      
      it "renders the view" do
        active = create :kpcc_program, air_status: "onair"
        get :index
      end
    end
    
    describe "controller" do
      it "assigns @kpcc_programs to active ordered by title" do
        active = create :kpcc_program, air_status: "onair"
        inactive = create :kpcc_program, air_status: "hidden"

        get :index
        assigns(:kpcc_programs).to_sql.should match /order by title/i
        assigns(:kpcc_programs).should eq [active]
      end
    
      it "assigns @external_programs to active ordered by title" do
        active = create :external_program, :from_rss, air_status: "onair"
        inactive = create :external_program, :from_rss, air_status: "hidden"

        get :index
        assigns(:external_programs).to_sql.should match /order by title/i
        assigns(:external_programs).should eq [active]
      end
    end
  end
  
  # ----------------------

  describe "GET /show" do
    describe "view" do
      render_views
      
      it "renders the view" do
        program = create :kpcc_program
        get :show, show: program.slug
      end
    end
    
    describe "controller" do
      describe "with XML" do
        it "renders xml template when requested" do
          program = create :kpcc_program
          get :show, show: program.slug, format: :xml
          response.should render_template 'programs/show'
          response.header['Content-Type'].should match /xml/
        end
      end
    
      describe "get_any_program" do
        it "assigns a KPCC program if slug matches" do
          program = create :kpcc_program
          get :show, show: program.slug
          assigns(:program).should eq program
        end
      
        it "finds an other program if requested" do
          program = create :external_program, :from_rss
          get :show, show: program.slug
          assigns(:program).should eq program
        end
      
        it "redirects to podcast_url if other program is present and request format is xml" do
          program = create :external_program, :from_rss, podcast_url: "http://podcast.com/podcast.xml"
          get :show, show: program.slug, format: :xml
          response.should redirect_to program.podcast_url
        end
      
        it "redirects to rss_url if no podcast_url present" do
          program = create :external_program, :from_rss, podcast_url: "", rss_url: "http://rss.com/rss.xml"
          get :show, show: program.slug, format: :xml
          response.should redirect_to program.rss_url
        end
      
        it "raises error if nothing found" do
          -> {
            get :show, show: "nonsense"
          }.should raise_error ActionController::RoutingError
        end
      end
    end
  end
  
  # ----------------------
  
  describe "GET /segment" do
    describe "view" do
      render_views
      
      it "renders the view" do
        segment = create :show_segment
        get :segment, segment.route_hash
      end
    end

    # ----------------------
    
    describe "controller" do
      describe "for invalid segment" do
        it "raises error for invalid id" do
          segment = create :show_segment
          -> { 
            get :segment, { show: segment.show.slug, id: "9999999", slug: segment.slug }.merge!(date_path(segment.published_at))
          }.should raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    # ----------------------
    
    describe "for valid segment" do
      it "assigns @segment" do
        segment = create :show_segment
        get :segment, segment.route_hash
        assigns(:segment).should eq segment
      end
    end
  end
  
  # ----------------------
  
  describe "GET /episode" do
    describe "view" do
      render_views
      
      it "renders the view" do
        episode = create :show_episode
        get :episode, episode.route_hash
      end
    end
  end
end
