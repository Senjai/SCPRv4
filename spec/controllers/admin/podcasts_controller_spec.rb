require "spec_helper"

describe Admin::PodcastsController do
  it_behaves_like "resource controller" do
    let(:resource) { :podcast }
  end
end
