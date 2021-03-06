require "spec_helper"

describe ProgramsController do
  describe "GET /archive" do
    describe "view" do
      render_views

      it "renders the view" do
        episode = create :show_episode, air_date: Time.new(2012, 3, 22)
        post :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
      end
    end

    describe "controller" do
      it "finds the episode for the program on the given date" do
        episode = create :show_episode, air_date: Time.new(2012, 3, 22)
        post :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
        assigns(:episode).should eq episode
      end

      it "assigns @date if date is given" do
        episode = create :show_episode, air_date: Time.new(2012, 3, 22)
        post :archive, show: episode.show.slug, archive: { "date(1i)" => episode.air_date.year, "date(2i)" => episode.air_date.month, "date(3i)" => episode.air_date.day }
        date = assigns(:date)
        date.should be_a Time
        date.beginning_of_day.should eq episode.air_date.beginning_of_day
      end

      it "works for external programs" do
        episode = create :external_episode, air_date: Time.new(2012, 3, 22)

        post :archive, show: episode.external_program.slug,
          :archive => {
            "date(1i)" => episode.air_date.year,
            "date(2i)" => episode.air_date.month,
            "date(3i)" => episode.air_date.day
          }

        assigns(:episode).should eq episode
      end
    end
  end

  describe "GET /schedule" do
    describe "view" do
      render_views

      it "renders the view" do
        create :recurring_schedule_rule
        get :schedule
      end
    end

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

  describe "GET /show" do
    describe "view" do
      render_views

      it "renders the view" do
        program = create :kpcc_program
        get :show, show: program.slug
      end

      it 'renders okay for segmented programs' do
        program = create :kpcc_program, :segmented
        create :show_segment, show: program
        get :show, show: program.slug
      end

      it 'renders okay for episodic programs' do
        program = create :kpcc_program, :episodic
        create :show_episode, show: program
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

        it "redirects to the podcast URL for external programs" do
          program = create :external_program, :from_rss
          get :show, show: program.slug, format: :xml
          response.should redirect_to program.podcast_url
        end
      end
    end
  end

  describe "GET /segment" do
    describe "view" do
      render_views

      it "renders the view" do
        segment = create :show_segment
        get :segment, segment.route_hash
      end
    end

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

    describe "for valid segment" do
      it "assigns @segment" do
        segment = create :show_segment
        get :segment, segment.route_hash
        assigns(:segment).should eq segment
      end
    end
  end

  describe "GET /episode" do
    describe "view" do
      render_views

      it "renders the view" do
        episode = create :show_episode
        get :episode, episode.route_hash
      end
    end

    describe "controller" do
      pending
    end
  end
end
