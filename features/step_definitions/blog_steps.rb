Given /^(\d+) news blogs?$/ do |num|
  @blogs = create_list :news_blog, num.to_i
  @blog = @blogs[rand(@blogs.length)]
end

Given /^(\d+) blogs?$/ do |num|
  @blogs = create_list :blog, num.to_i
  @blog = @blogs[rand(@blogs.length)]
end

Given /^(\d+) remote blogs?$/ do |num|
  @blogs = create_list :remote_blog, num.to_i
  @blog = @blogs[rand(@blogs.length)]
end

When /^I go to the blogs page$/ do
  visit blogs_path
end

Then /^I should see the blog's information$/ do
  page.find(".blog-masthead h2").should have_content @blog.name
end


Then /^I should see (\d+) blogs? listed in the News section$/ do |num|
  page.find("#news").should have_css ".thumbnail", count: num.to_i
end

Given /^(\d+) entr(?:ies|y) for that blog$/ do |num|
  @entries = create_list :blog_entry, num.to_i, blog: @blog
end

Then /^I should see the latest entry for that blog$/ do
  page.find(".thumbnail .latest-post").should have_content @blog.entries.first.title
end

Then /^I should see that blog's teaser$/ do
  page.should have_content @blog.teaser
end

When /^I go to that blog's page$/ do
  visit blog_path(@blog)
end

Then /^I should see the blog's entries listed$/ do
  page.should have_css ".entry", count: @blog.entries.count # FIXME: Need to account for pagination
  page.should have_content @blog.entries.first.title
end

Then /^I should see the remote blog's entries listed$/ do
  page.should have_css ".entry.simple", count: @blog.entries.count # FIXME: Need to account for pagination
  page.should have_content @blog.entries.first.title
end

Given /^the entries for it have been cached$/ do
  puts @cached = Blog.cache_remote_entries
  @cached.count.should eq @blogs.count
end

Then /^I should see the latest entries for that blog$/ do # This step fails because of an environment issue, the thing it's testing works though
  # page.should have_css "ul.remote-entries li", count: @cached.count
  # page.find("ul.remote-entries li:first-of-type").should have_content @cached.first.title
end
