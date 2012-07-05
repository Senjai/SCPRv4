require "spec_helper"

describe ProgramsController do
  
  # ----------------------
  
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
  
  # ----------------------

  describe "GET /schedule" do
    it "assigns @schedule_slots to all Schedule objects" do
      create_list :schedule, 3
      get :schedule
      assigns(:schedule_slots).should eq Schedule.all
    end
  end

  # ----------------------
   
  describe "GET /index" do
    it "assigns @kpcc_programs to active ordered by title" do
      active = create :kpcc_program, air_status: "onair"
      inactive = create :kpcc_program, air_status: "hidden"

      get :index
      assigns(:kpcc_programs).to_sql.should match /order by title/i
      assigns(:kpcc_programs).should eq [active]
    end
    
    it "assigns @other_programs to active ordered by title" do
      active = create :other_program, air_status: "onair"
      inactive = create :other_program, air_status: "hidden"

      get :index
      assigns(:other_programs).to_sql.should match /order by title/i
      assigns(:other_programs).should eq [active]
    end
  end
  
  # ----------------------

  describe "GET /show" do
    describe "with XML" do
      it "renders xml template when requested" do
        program = create :kpcc_program
        get :show, show: program, format: :xml
        response.should render_template 'programs/show', format: :xml
      end
    end
    
    describe "get_program" do
      it "assigns a KPCC program if slug matches" do
        program = create :kpcc_program
        get :show, show: program
        assigns(:program).should eq program
      end
      
      it "redirects using the quick slug if present" do
        program = create :kpcc_program, quick_slug: "pm"
        get :show, quick_slug: program.quick_slug
        response.should redirect_to program_path(program)
      end
      
      it "finds an other program if requested" do
        program = create :other_program
        get :show, show: program
        assigns(:program).should eq program
      end
      
      it "redirects if nothing found" do
        -> {
          get :show, show: "nonsense"
        }.should raise_error ActionController::RoutingError
      end
    end
  end
  
  # ----------------------
  
  describe "GET /segment" do
    describe "for invalid segment" do
      it "raises error for invalid id" do
        segment = create :show_segment
        -> { 
          get :segment, { show: segment.show.slug, id: "9999999", slug: segment.slug }.merge!(date_path(segment.published_at))
        }.should raise_error ActionController::RoutingError
      end
      
      it "raises error for unpublished" do
        segment = create :show_segment, status: ContentBase::STATUS_DRAFT
        -> { 
          get :segment, { show: segment.show.slug, id: segment.id, slug: segment.slug }.merge!(date_path(segment.published_at))
        }.should raise_error ActionController::RoutingError
      end
    end
    
    describe "for valid segment" do
      it "assigns @segment" do
        segment = create :show_segment
        get :segment, { show: segment.show.slug, id: segment.id, slug: segment.slug }.merge!(date_path(segment.published_at))
        assigns(:segment).should eq segment
      end
    end
  end
  # ----------------------
  
  
end