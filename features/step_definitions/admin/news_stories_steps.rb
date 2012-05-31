When /^I fill in all of the required fields with valid information$/ do
  news_story = build :news_story
  news_story.attributes.keys.each do |attrib|
    field_id = "news_story_#{attrib}"
    if page.has_css ".required ##{field_id}"
      fill_in field_id, with: news_story.send(attrib)
    end
  end
end

Then /^I should be on the "(.*?)" page$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a success message$/ do
  pending # express the regexp above with the code you wish you had
end
