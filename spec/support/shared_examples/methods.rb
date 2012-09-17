__END__

#-----------------

describe "set_published_at_to_now" do
  it "sets published at to now" do
    object = build symbolize(c)
    time   = object.set_published_at_to_now
    object.published_at.should eq time
  end
end

#-----------------
    
describe "callbacks" do
  it "runs set_published_at_to_now if publishing? is true" do
    object = build symbolize(c)
    object.stub(:publishing?) { true }
    object.should_receive :set_published_at_to_now
    object.save!
  end
  
  it "does not run set_published_at_to_now if publishing? is false" do
    object = build symbolize(c)
    object.stub(:publishing?) { false }
    object.should_not_receive :set_published_at_to_now
    object.save!
  end
end