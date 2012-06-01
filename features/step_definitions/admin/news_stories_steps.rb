When /^I fill in all of the required fields with valid information$/ do
  fill_required_fields_with_attributes_from build(:news_story)
end

When /^I do not fill in the required fields$/ do
  fill_required_fields_with_attributes_from NewsStory.new
end
