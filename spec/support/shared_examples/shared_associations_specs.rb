##
# Shared Associations
# Model::Associations
#

#---------------
# ContentAlarmAssociation
shared_examples_for "content alarm association" do
  it { should have_one(:alarm).class_name("ContentAlarm").dependent(:destroy) }
end
