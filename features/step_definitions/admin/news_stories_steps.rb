#### Setup
Given /^(?:a? )?news stor(?:ies|y) with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create(:news_story, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @news_story = NewsStory.all[rand(NewsStory.count.to_i)]
end

Given /^(\d+) news stor(?:ies|y)$/ do |num|
  @news_stories = create_list :news_story, num.to_i
  @news_story = @news_stories[rand(@news_stories.size)]
  @news_stories.count.should eq num.to_i
end



#### Actions
When /^I (?:fill in|update) all of the required fields with valid information$/ do
  fill_required_fields_with_attributes_from build(:news_story)
end

When /^I do not fill in the required fields$/ do
  fill_required_fields_with_attributes_from NewsStory.new
end



#### Assertions
Then /^there should be (\d+) news stor(?:y|ies)$/ do |num|
  NewsStory.count.should eq num.to_i
end

Then /^the news story's attributes should be updated$/ do
  pending
end



#### Routing
When /^I go to edit (?:that|a) news story$/ do
  visit edit_admin_news_story_path(@news_story.id)
end
