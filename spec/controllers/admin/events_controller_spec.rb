require "spec_helper"

describe Admin::EventsController do
  it_behaves_like "resource controller" do
    let(:resource) { :event }
  end
end
