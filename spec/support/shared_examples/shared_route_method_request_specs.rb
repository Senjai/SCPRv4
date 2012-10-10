##
# Route method request specs
#
# A way to make sure each model's link_path 
# and remote_link_path,
# are generating a real path
#
# Requires `valid_record` to be passed in.
#
shared_examples_for "front-end routes request" do
  describe "Route Methods" do
    before :each do
      valid_record.save!
      Scprv4::Application.reload_routes!
    end
    
    it "returns success when following link_path" do
      visit valid_record.link_path
      current_path.should eq valid_record.link_path
    end
  
    it "returns success when following remote_link_path" do
      visit valid_record.remote_link_path
      current_url.should eq valid_record.remote_link_path
    end  
  end
end

#---------------------------
