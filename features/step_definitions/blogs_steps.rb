#### Blog Creation
Given /^(\d+) blogs?$/ do |num|
  @blogs = create_list :blog, num.to_i
  @blog = @blogs[rand(@blogs.length)]
  @blogs.count.should eq Blog.all.count
end

Given /^(?:a )?blogs? with the following attributes?:$/ do |table|
  @blogs = []
  table.hashes.each do |attributes|
    @blogs << create(:blog, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @blog = Blog.all[rand(Blog.count.to_i)]
end


#### Finders
Then /^I should see the blog's information$/ do
  page.find(".blog-masthead h2").should have_content @blog.name
end

Then /^I should see (\d+) blogs? listed in the News section$/ do |num|
  page.find("#news").should have_css ".thumbnail", count: num.to_i
end

Then /^I should see that blog's teaser$/ do
  page.should have_content @blog.teaser
end

Then /^I should see the recent posts widget for that blog$/ do
  page.should have_css ".recent-posts" 
  page.should have_css ".recent-posts li", count: @blog.entries.published.limit(5).count
end


#### Routing
When /^I go to the blogs page$/ do
  visit blogs_path
end

When /^I go to (?:the|that) blog's page$/ do
  visit blog_path(@blog)
end

Then /^I should be redirected to the blogs page$/ do
  current_path.should eq blogs_path
end
