#### Blog Creation
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
  page.find("#news").should have_css ".blog-widget", count: num.to_i
end


#### Routing
When /^I go to the blogs page$/ do
  visit blogs_path
end

When /^I go to (?:the|that) blog's page$/ do
  visit blog_path(@blog.slug)
end
