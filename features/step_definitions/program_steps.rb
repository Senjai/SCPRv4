Given /^there are (\d+) kpcc programs$/ do |num|
  @kpcc_programs = create_list :kpcc_program, num.to_i
  @kpcc_program = @kpcc_programs[rand(@kpcc_programs.length)]
end

Given /^there are (\d+) other programs$/ do |num|
  @other_programs = create_list :other_program, num.to_i
  @other_program = @other_programs[rand(@other_programs.length)]
end

When /^I go to the programs page$/ do
  visit programs_path
end
