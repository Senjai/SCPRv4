#### Setup
Given /^there (?:is|are) (\d+) (kpcc|other) programs?$/ do |num, program_type|
  factory = "#{program_type}_program"
  @programs = create_list factory.to_sym, num.to_i
  @program = @programs[rand(num.to_i)]
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

Then /^I should not see any programs$/ do
  page.should_not have_css ".programs-list"
  page.should_not have_css "#featured-programs .headshot"
end



#### Routing
When /^I go to the programs page$/ do
  visit programs_path
  current_path.should eq programs_path
end

When /^I go to (?:the|a|that) program's page$/ do
  visit program_path @program.slug
  current_path.should eq program_path @program.slug
end

Then /^I should be on (?:the|that) program's page$/ do
  current_path.should eq program_path @program.slug
end
