#### Setup
Given /^(?:a? )?categor(?:y|ies) with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create(:category, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @category = Category.all[rand(Category.count.to_i)]
end


#### Finders
Then /^I should see the category's title$/ do
  page.should have_content @category.title
end

Then /^I should not see the category's title$/ do
  page.should_not have_content @category.title
end


#### Routing
When /^I go to (?:that|the) category's page$/ do
  Scprv4::Application.reload_routes!
  visit @category.link_path
end
