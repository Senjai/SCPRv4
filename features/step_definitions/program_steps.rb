Given /^there are (\d+) kpcc programs$/ do |num|
  @kpcc_programs = create_list :kpcc_program, num.to_i
  @kpcc_program = @kpcc_programs[rand(@kpcc_programs.length)]
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
  @featured_program = create :kpcc_program, title: title, slug: slug
end


When /^I go to the program's page$/ do
  visit program_path @featured_program
end

Then /^I should see the program's information$/ do
  page.find(".show-title h2").should have_content @featured_program.title
end

Then /^I should see a headshot of the program's host$/ do
  page.find(".show-meta.#{@featured_program.slug}")["background-image"].should_not be_blank
end

When /^I go to a program's page$/ do
  
end