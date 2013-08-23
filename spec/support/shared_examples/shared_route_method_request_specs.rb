##
# Route method request specs
#
# A way to make sure each model's public_path
# and public_url,
# are generating a real path
#
# Requires `valid_record` to be passed in.
#
shared_examples_for "front-end routes" do
  describe "Route Methods" do
    before :each do
      valid_record.save!
    end

    it "returns success when following public_path" do
        visit valid_record.public_path
      current_path.should eq valid_record.public_path
    end
  end
end

#---------------------------

shared_examples_for "admin routes" do
  describe "Admin Paths" do
    before :each do
      login
      valid_record.save!
    end

    it "returns success when following admin_edit_path" do
      visit valid_record.admin_edit_path
      current_path.should eq valid_record.admin_edit_path
    end

    it "returns success when following admin_show_path" do
      visit valid_record.admin_show_path
      current_path.should eq valid_record.admin_edit_path
    end

    it "returns success when following admin_new_path" do
      visit valid_record.class.admin_new_path
      current_path.should eq valid_record.class.admin_new_path
    end

    it "returns success when following admin_index_path" do
      visit valid_record.class.admin_index_path
      current_path.should eq valid_record.class.admin_index_path
    end
  end
end
