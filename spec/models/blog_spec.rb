require "spec_helper"

describe Blog do  
  describe "scopes" do
    describe "::active" do
      it "returns only active blogs" do
        active_blogs   = create_list :blog, 1, is_active: true
        inactive_blogs = create_list :blog, 2, is_active: false
        Blog.active.should eq active_blogs
      end
    end
  end
end
