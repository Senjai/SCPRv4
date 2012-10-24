require "spec_helper"

describe DataPoint do
  let(:valid_record) { build :data_point }
  let(:updated_record) { build :data_point }
  let(:invalid_record) { build :data_point, data_key: nil }

  it_behaves_like "managed resource create"
  it_behaves_like "managed resource destroy"
  it_behaves_like "save options"
  it_behaves_like "admin routes"
  it_behaves_like "versioned model"
  
  #------------------------
  
  describe "Update" do
    before :each do
      login
      # Touch them so their associations get created
      valid_record
      invalid_record
      updated_record
    end

    #------------------------

    describe "Update" do
      before :each do
        valid_record.save!
        visit valid_record.admin_edit_path
      end

      context "valid" do
        it "updates attributes" do
          fill_required_fields(updated_record)
          click_button "edit"
          page.should have_css ".alert-success"
          current_path.should eq valid_record.admin_edit_path
        end
      end
    end
  end
end
