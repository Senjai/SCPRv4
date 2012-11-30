shared_examples_for "versioned model" do
  describe "Versions" do
    before :each do
      login
      
      # touch records to created associated objects
      valid_record
      updated_record
    end
    
    context "new record" do
      it "saves an initial version" do
        visit described_class.admin_new_path
        fill_required_fields(valid_record)
        click_button "edit"
        described_class.count.should eq 1
        new_record = described_class.first
        new_record.versions.size.should eq 1
        click_link "history"
        page.should have_content "Created #{described_class.name.demodulize.titleize} ##{new_record.id}"
      end
    end
    
    context "existing record" do
      it "saves a new version" do
        valid_record.save!
        visit valid_record.admin_edit_path
        fill_required_fields(updated_record)
        click_button "edit"
        updated = described_class.find(valid_record.id)
        updated.versions.size.should eq 2
        click_link "history"
        current_path.should eq admin_history_path(valid_record.class.route_key, valid_record.id)
        page.should have_content "View"
        first(:link, "View").click # Capybara 2.0 throws error for ambigious match.
      end
    end
  end
end
