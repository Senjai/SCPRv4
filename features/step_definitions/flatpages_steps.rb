#### Setup
Given /^(?:a? )?flatpages? with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create(:flatpage, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @flatpage = Flatpage.all[rand(Flatpage.count.to_i)]
end


#### Finders

Then /^I should see the flatpage content$/ do
  page.should have_content @flatpage.content
end

Then /^I should see the sidebar$/ do
  page.should have_css "#sidebar"
end

When /^I should not see the sidebar$/ do
  page.should_not have_css "#sidebar"
end

When /^I should only see the flatpage content$/ do
  page.should_not have_css "container-fluid" # Not perfect but it's okay... just making sure a layout is not rendered
end



#### Routing
When /^I go to (?:that|the) flatpage's url$/ do
  Scprv4::Application.reload_routes!
  visit @flatpage.url
end

Then /^I should be redirected to the redirect url$/ do
  current_path.should eq @flatpage.redirect_url
end
