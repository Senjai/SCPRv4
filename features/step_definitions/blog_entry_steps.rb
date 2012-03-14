#### Setup
Given /^(\d+) blog entr(?:ies|y)$/ do |num|
  @blog_entries = create_list :blog_entry, num.to_i, blog: @blog
  @blog_entry = @blog_entries[rand(@blog_entries.length)]
  @blog_entries.count.should eq num.to_i
end

Given /^(\d+) entr(?:ies|y) for that blog$/ do |num|
  @entries = create_list :blog_entry, num.to_i, blog: @blog
end

Given /^the blog entry has (\d+) backward related articles?$/ do |num|
  @related = create_list :brel, num.to_i, content: @blog_entry
end

Given /^the blog entry has (\d+) forward related articles?$/ do |num|
  @related = create_list :frel, num.to_i, related: @blog_entry
end

Given /^the blog entry has (\d+) related links?$/ do |num| 
  @links = create_list :link, num.to_i, content: @blog_entry
end


#### Finders
Then /^I should see a list of blog entries$/ do
  page.should have_css ".entry", count: @blog_entries.count # FIXME Account for pagination
end

Then /^I should see article meta for each entry$/ do
  page.should have_css ".article-meta", count: @blog_entries.count # FIXME Account for pagination
end

Then /^I should see the latest entry for that blog$/ do
  page.find(".thumbnail .latest-post").should have_content @blog.entries.first.title
end

Then /^I should see the latest entry for that remote blog$/ do
  page.find(".thumbnail .latest-post").should have_css "a" # Just checking for a link but it's probably okay
end

Then /^I should see the blog's entries listed$/ do
  page.should have_css ".entry", count: @blog.entries.count # FIXME: Need to account for pagination
  page.should have_content @blog.entries.first.title
end

Then /^I should see a timestamp for the latest entry$/ do
  page.should have_css ".latest-post time", count: @blogs.count
end


#### Routing
When /^I go to their blog's page$/ do
  visit blog_path @blog
  current_path.should eq blog_path(@blog)
end

When /^I go to that blog entry's page$/ do
  visit @blog_entry.link_path
end

#### Utility
Given /^the entry for it has been cached$/ do
  puts @cached = Blog.cache_remote_entries
  @cached.count.should eq @blogs.count
end


