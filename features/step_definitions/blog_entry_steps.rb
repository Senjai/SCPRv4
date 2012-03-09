Given /^(\d+) blog entr(?:ies|y)$/ do |num|
  @blog_entries = create_list :blog_entry, num.to_i, blog: @blog
  @blog_entry = @blog_entries[rand(@blog_entries.length)]
  @blog_entries.count.should eq num.to_i
end

When /^I go to their blog's page$/ do
  visit blog_path @blog
  current_path.should eq blog_path(@blog)
end

Then /^I should see a list of blog entries$/ do
  page.should have_css ".entry", count: @blog_entries.count # FIXME Account for pagination
end

Then /^I should see article meta for each entry$/ do
  page.should have_css ".article-meta", count: @blog_entries.count # FIXME Account for pagination
end
