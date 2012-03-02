Given /^there (?:is|are) (\d+) kpcc programs?$/ do |num|
  @kpcc_programs = create_list :kpcc_program, num.to_i
  @kpcc_program = @kpcc_programs[rand(num.to_i)]
  KpccProgram.all.count.should eq num.to_i
end

Given /^there are (\d+) other programs$/ do |num|
  @other_programs = create_list :other_program, num.to_i
  @other_program = @other_programs[rand(@other_programs.length)]
  OtherProgram.all.count.should eq num.to_i
end

When /^I go to the programs page$/ do
  visit programs_path
end

Given /^a program titled "([^"]*)" with slug "([^"]*)"$/ do |title, slug|
  @kpcc_program = create :kpcc_program, title: title, slug: slug
end


When /^I go to the program's page$/ do
  visit program_path @kpcc_program
end

Then /^I should see the program's information$/ do
  find(".show-title h2").should have_content @kpcc_program.title
end

Then /^I should see a headshot of the program's host$/ do
  page.should have_xpath("//div[contains(@class, '#{@kpcc_program.slug}')]") # Need to figure out how to actually check for background-image attribute.
end

When /^I go to a program's page$/ do
  visit program_path @kpcc_program
end