__END__
describe "publishing?" do
  it "returns true if status was changed and is now published" do
    object = build symbolize(c)
    object.stub(:status_changed?) { true }
    object.stub(:published?) { true }
    object.publishing?.should be_true
  end
  
  it "returns false if status was not changed" do
    object = build symbolize(c)
    object.stub(:status_changed?) { false }
    object.stub(:published?) { true }
    object.publishing?.should be_false
  end
  
  it "returns false if status is not published" do
    object = build symbolize(c)
    object.stub(:status_changed?) { true }
    object.stub(:published?) { false }
    object.publishing?.should be_false
  end
  
  it "returns false if status was not changed and status not published" do
    object = build symbolize(c)
    object.stub(:status_changed?) { false }
    object.stub(:published?) { false }
    object.publishing?.should be_false
  end
end

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