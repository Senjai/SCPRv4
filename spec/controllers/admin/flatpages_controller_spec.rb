require "spec_helper"

describe Admin::FlatpagesController do
  it_behaves_like "resource controller" do
    let(:resource) { :flatpage }
  end
end