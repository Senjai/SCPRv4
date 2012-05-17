#### Setup
Given /^there (?:is|are) (\d+) (kpcc|other) programs?$/ do |num, program_type|
  factory = "#{program_type}_program"
  @programs = create_list factory.to_sym, num.to_i
  @program = @programs[rand(num.to_i)]
end

Given /^a program titled "([^"]*)" with slug "([^"]*)"$/ do |title, slug|
  @program = create :kpcc_program, title: title, slug: slug
end

Given /^(?:an? )?(kpcc|other) programs? with the following attributes?:$/ do |program_type, table|
  factory = "#{program_type}_program"
  klass = factory.camelize.constantize
  table.hashes.each do |attributes|
    create(factory.to_sym, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @program = klass.all[rand(klass.count.to_i)]
end



#### Finders
Then /^I should see the program's information$/ do
  find("h1.page-title").should have_content @program.title
end

Then /^I should see a headshot of the program's host$/ do
  page.should have_xpath("//div[contains(@class, '#{@program.slug}')]")
end

Then /^I should see a list of that program's podcast entries$/ do
  pending "caching not enabled in testing environment- need to work around this or enable it for one step"
end

Then /^I should see a list of that program's RSS entries$/ do
  pending "caching not enabled in testing environment- need to work around this or enable it for one step"
end

Then /^I should not see any podcast entries$/ do
  pending
  # page.should_not have_content "<h2>Recently</h2>" # TODO: Need a better way to test this
end

Then /^I should not see any RSS entries$/ do
  pending
  # page.should_not have_content "<h2>Latest News</h2>" # TODO: Need a better way to test this
end

Then /^I should not see any programs$/ do
  page.should_not have_css ".programs-list"
  page.should_not have_css "#featured-programs .headshot"
end

Then /^I should see the featured programs in the correct order$/ do
  KpccProgram.all.each do |program|
    page.find("#featured-programs li.#{program.slug}").should have_content program.title
  end
end



#### Utility
Given /^the feeds are cached$/ do
  @program.cache.should be_true
  Rails.cache.fetch("ext_program:#{@program.slug}:podcast").should_not be_blank if @program.podcast_url.present?
  Rails.cache.fetch("ext_program:#{@program.slug}:rss").should_not be_blank if @program.rss_url.present?
end

Given /^the program is currently on$/ do
  schedule = create :schedule, kpcc_program_id: @program.id, program: @program.title
  Schedule.stub(:on_now) { schedule }
  Schedule.on_now.programme.should eq @program
end



#### Routing
When /^I go to the programs page$/ do
  visit programs_path
  current_path.should eq programs_path
end

Then /^I should be on the programs page$/ do
  current_path.should eq programs_path
end

When /^I go to (?:the|a|that) program's page$/ do
  visit program_path @program
  current_path.should eq program_path @program
end

When /^I go to a program page with slug "([^"]*)"$/ do |slug|
  visit program_path(show: slug)
end

When /^I visit the shallow path for that program$/ do
  Scprv4::Application.reload_routes!
  visit "/#{@program.quick_slug}"
end

Then /^I should be on (?:the|that) program's page$/ do
  current_path.should eq program_path @program
end

Then /^I should not be on (?:the|that) program's page$/ do
  current_path.should_not eq program_path @program
end
