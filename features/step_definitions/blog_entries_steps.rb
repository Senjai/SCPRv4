#### Setup
Given /^(\d+) blog entr(?:ies|y)$/ do |num|
  @blog_entries = create_list :blog_entry, num.to_i, blog: @blog
  @blog_entry = @blog_entries[rand(@blog_entries.length)]
  @blog_entries.count.should eq num.to_i
end

Given /^a blog entry$/ do
  @blog_entry = create :blog_entry
end

Given /^(?:a? )?blog entr(?:ies|y) with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create(:blog_entry, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @blog_entry =  BlogEntry.all[rand(BlogEntry.count.to_i)]
end


#### Finders
Then /^I should see a list of blog entries$/ do
  page.should have_css ".entry", count: @blog_entries.count # FIXME Account for pagination
end

Then /^I should see the latest entry for that blog$/ do
  page.find(".blog-widget").should have_content @blog.entries.first.short_headline
end

Then /^I should see the latest entry for that remote blog$/ do
  page.find(".thumbnail .latest-post").should have_css "a" # Just checking for a link but it's probably okay
end

Then /^I should see the blog's entries listed$/ do
  page.should have_css ".entry", count: @blog.entries.count # FIXME: Need to account for pagination
  page.should have_content @blog.entries.first.headline
end

Then /^I should see a timestamp for the latest entry$/ do
  page.should have_css ".latest-post time", count: @blogs.count
end


#### Routing
When /^I go to their blog's page$/ do
  visit blog_path @blog.slug
  current_path.should eq blog_path(@blog.slug)
end

When /^I go to that blog entry's page$/ do
  visit @blog_entry.link_path
end

#### Utility
Given /^the entry for it has been cached$/ do
  @cached = Blog.cache_remote_entries
  @cached.count.should eq @blogs.count
end


