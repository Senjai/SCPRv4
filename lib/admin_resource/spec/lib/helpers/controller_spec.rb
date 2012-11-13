require File.expand_path("../../../spec_helper", __FILE__)

describe AdminResource::Helpers::Controller do
  let(:controller) { AdminResource::Test::PeopleController.new }
  let(:person) { Person.create(name: "Bryan") }
  
  pending
  
end
