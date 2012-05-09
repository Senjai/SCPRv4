Given /^(?:a )?breaking news alerts? with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    attributes["created_at"] = Chronic.parse(attributes["created_at"]) if attributes["created_at"].present?
    create(:breaking_news_alert, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @breaking_news_alert = BreakingNewsAlert.all[rand(BreakingNewsAlert.count.to_i)]
end

Then /^I should see breaking news$/ do
  page.should have_css "#breaking-news"
end

Then /^I should not see breaking news$/ do
  page.should_not have_css "#breaking-news"
end