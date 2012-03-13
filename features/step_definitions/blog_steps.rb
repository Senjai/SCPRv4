#### Blog Creation
Given /^(\d+) news blogs?$/ do |num|
  @blogs = create_list :news_blog, num.to_i
  @blog = @blogs[rand(@blogs.length)]
  @blogs.count.should eq num.to_i
end

Given /^(\d+) blogs?$/ do |num|
  @blogs = create_list :blog, num.to_i
  @blog = @blogs[rand(@blogs.length)]
  @blogs.count.should eq num.to_i
end

Given /^(\d+) remote blogs?$/ do |num|
  @blogs = create_list :remote_blog, num.to_i
  @blog = @blogs[rand(@blogs.length)]
  @blogs.count.should eq num.to_i
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


#### Routing
When /^I go to the blogs page$/ do
  visit blogs_path
end

When /^I go to that blog's page$/ do
  visit blog_path(@blog)
end

Then /^I should be redirected to the blogs page$/ do
  current_path.should eq blogs_path
end