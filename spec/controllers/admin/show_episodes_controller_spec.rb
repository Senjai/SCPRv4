require "spec_helper"

describe Outpost::ShowEpisodesController do
  it_behaves_like "resource controller" do
    let(:resource) { :show_episode }
  end
end
