##
# Shared Associations
# Model::Associations
#

#---------------
# ContentAlarmAssociation
shared_examples_for "content alarm association" do
  it { should have_one(:alarm).class_name("ContentAlarm").dependent(:destroy) }
end

#---------------
# AssetAssociation
shared_examples_for "asset association" do
  it { should have_many(:assets).class_name("ContentAsset").dependent(:destroy) }
end

#---------------
# AudioAssociation
shared_examples_for "audio association" do
  it { should have_many(:audio).order("position asc") }
end
