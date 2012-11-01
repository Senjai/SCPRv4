require "spec_helper"

describe ProgramsController do
  render_views
  
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
    it "assigns @schedule_slots to all RecurringScheduleSlot objects" do
      create_list :recurring_schedule_slot, 3
      get :schedule
      assigns(:schedule_slots).should eq RecurringScheduleSlot.all
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
        program = create :other_program
        get :show, show: program.slug
        assigns(:program).should eq program
      end
      
      it "redirects to podcast_url if other program is present and request format is xml" do
        program = create :other_program
        get :show, show: program.slug, format: :xml
        response.should redirect_to program.podcast_url
      end
      
      it "redirects to rss_url if no podcast_url present" do
        program = create :other_program, podcast_url: ""
        get :show, show: program.slug, format: :xml
        response.should redirect_to program.rss_url
      end
      
      it "raises error if nothing found" do
        -> {
          get :show, show: "nonsense"
        }.should raise_error ActionController::RoutingError
      end
    end
    
    describe "redirect_for_quick_slug" do
      it "redirects using the quick slug if present" do
        program = create :kpcc_program, quick_slug: "pm"
        get :show, quick_slug: program.quick_slug
        response.should redirect_to program_path(program.slug)
      end
      
      it "doesn't do anything if quick_slug isn't present" do
        program = create :kpcc_program
        controller.should_not_receive(:redirect_for_quick_slug)
        get :show, program.route_hash
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
        }.should raise_error ActiveRecord::RecordNotFound
      end
      
      it "raises error for unpublished" do
        segment = create :show_segment, status: ContentBase::STATUS_DRAFT
        -> { 
          get :segment, { show: segment.show.slug, id: segment.id, slug: segment.slug }.merge!(date_path(segment.published_at))
        }.should raise_error ActiveRecord::RecordNotFound
      end
    end

    # ----------------------
    
    describe "for valid segment" do
      it "assigns @segment" do
        segment = create :show_segment
        get :segment, { show: segment.show.slug, id: segment.id, slug: segment.slug }.merge!(date_path(segment.published_at))
        assigns(:segment).should eq segment
      end
    end
  end
  
  # ----------------------
  
  describe "GET /episode" do
    describe "get_kpcc_program!" do
      let(:program) { create :kpcc_program, episode_count: 1 }
      
      it "returns the program if slug exists" do
        get :episode, program.episodes.last.route_hash
        assigns(:program).should eq program
      end
      
      it "raises an error if slug doesn't exist" do
        -> {
          get :episode, program.episodes.last.route_hash.merge!(show: "nonsense")
        }.should raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  # ----------------------
  
  
end