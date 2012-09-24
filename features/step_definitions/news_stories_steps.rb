#### Setup
Given /^(?:a? )?news stor(?:ies|y) with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create(:news_story, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @news_story = NewsStory.all[rand(NewsStory.count.to_i)]
  @object     = @news_story
end

Given /^(\d+) news stor(?:ies|y)$/ do |num|
  @news_stories = create_list :news_story, num.to_i
  @news_story   = @news_stories[rand(@news_stories.size)]
  @object       = @news_story
  NewsStory.count.should eq num.to_i
end



#### Assertions
Then /^there should be (\d+) news stor(?:y|ies)$/ do |num|
  NewsStory.count.should eq num.to_i
end

Then /^the news story's attributes should be updated$/ do
  visit @news_story.link_path
  within ".story article" do
    page.should have_content @updated_object.headline
  end
end

When /^I mark the status as "(.*?)"$/ do |status|
  select status, from: "news_story_status"
end


#### Routing
When /^I go to edit (?:that|a) news story$/ do
  visit edit_admin_news_story_path(@news_story.id)
end
