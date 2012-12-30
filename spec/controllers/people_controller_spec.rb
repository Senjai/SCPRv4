require "spec_helper"

describe PeopleController do
  describe "GET /index" do
    describe "view" do
      render_views
      
      it "renders the view" do
        create :bio, is_public: true
        get :index
      end
    end
    
    #-----------------
    
    describe "controller" do
      before :each do
        create :bio, is_public: false
        create :bio, is_public: true
        get :index
      end

      it "only shows public bios" do
        assigns(:bios).reject { |b| b.is_public == true }.should be_blank
      end
    end
  end

  #-------------------
  
  describe "GET /bio" do    
    describe "view" do
      render_views
      
      it "renders the view" do
        content = create :content_shell
        bylines = create_list :byline, 2, content: content
        Bio.any_instance.should_receive(:indexed_bylines).and_return(Kaminari.paginate_array(bylines).page(1))
        
        bio = create :bio
        get :bio, slug: bio.slug
      end
    end
    
    #-------------------
    
    describe "controller" do          
      it "redirects if the bio isn't found" do
        get :bio, slug: "nonsense"
        response.should be_redirect
      end
    end
  end
end