#### Setup
Given /^(?:a? )?sections? with the following attributes?:$/ do |table|
  @sections = []
  table.hashes.each do |attributes|
    @sections.push create(:section, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @section = @sections[rand(@sections.size.to_i)]
  @object  = @section
  Scprv4::Application.reload_routes!
end

Given /^(\d+) sections?$/ do |num|
  @sections = create_list :section, num.to_i
  @section  = @sections[rand(@sections.size)]
  @object   = @section
  Section.count.should eq num.to_i
  Scprv4::Application.reload_routes!
end



#### Finders
Then /^I should see the latest content$/ do
  page.should have_content @section.title
end



#### Assertions
Then /^there should be (\d+) sections?$/ do |num|
  Section.count.should eq num.to_i
end

Then /^the section's attributes should be updated$/ do
  Scprv4::Application.reload_routes!
  visit section_path(@section.reload.slug)
  within ".section-page" do
    page.should have_content @updated_object.title
  end
end



#### Actions
When /^I go to edit that section$/ do
  visit edit_admin_section_path(@section)
end

When /^I go to that section's XML feed$/ do
  visit section_path(@section.slug, format: :xml)
end
