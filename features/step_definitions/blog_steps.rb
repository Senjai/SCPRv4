Given /^(\d+) news blogs?$/ do |num|
  @blogs = create_list :news_blog, num.to_i
end

When /^I go to the blogs page$/ do
  visit blogs_path
end

Then /^I should see (\d+) blogs? listed in the News section$/ do |num|
  news_id = "#news"
  page.find(news_id).should have_css ".thumbnail", count: num.to_i
end

Given /^a blog$/ do
  @blog = create :blog
end

Given /^(\d+) entr(?:ies|y) for that blog$/ do |num|
  @entries = create_list :blog_entry, num.to_i, blog: @blog
end

Then /^I should see the latest entry for that blog$/ do
  page.find(".thumbnail .latest-post").should have_content @blog.entries.published.first.headline
end
