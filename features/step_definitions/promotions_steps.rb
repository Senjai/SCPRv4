#### Setup
Given /^(?:a? )?promotions? with the following attributes?:$/ do |table|
  @promotions = []
  table.hashes.each do |attributes|
    @promotions.push create(:promotion, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @promotion = @promotions[rand(@promotions.size.to_i)]
  @object    = @promotion
end

Given /^(\d+) promotions?$/ do |num|
  @promotions = create_list :promotion, num.to_i
  @promotion  = @promotions[rand(@promotions.size)]
  @object     = @promotion
  Promotion.count.should eq num.to_i
end



#### Assertions
Then /^there should be (\d+) promotions?$/ do |num|
  Promotion.count.should eq num.to_i
end

Then /^the promotion's attributes should be updated$/ do
  pending
end



#### Actions
When /^I go to edit that promotion$/ do
  visit edit_admin_promotion_path(@promotion)
end
