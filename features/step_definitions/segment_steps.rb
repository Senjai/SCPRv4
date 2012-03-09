When /^I go to that segment's page$/ do
  visit @segment.link_path # FIXME use actual url helper here
  current_path.should eq @segment.link_path
end

Then /^I should see the segment's information$/ do
  page.find("h1.story-title").should have_content @segment.headline
end

Then /^I should see article meta for the segment$/ do
  page.should have_css ".article-meta", count: 1
end