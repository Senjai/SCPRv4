require "spec_helper"

describe Admin::BlogEntriesController do
  it_behaves_like "resource controller" do
    let(:resource) { :blog_entry }
  end
end
