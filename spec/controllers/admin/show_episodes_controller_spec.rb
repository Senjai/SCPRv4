require "spec_helper"

describe Admin::ShowEpisodesController do
  it_behaves_like "resource controller" do
    let(:resource) { :show_episode }
  end
end