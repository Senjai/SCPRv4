#### Setup
Given /^there (?:is|are) (\d+) homepages?$/ do |num|
  @homepages = create_list :homepage, num.to_i
  @homepage = @homepages[rand(num.to_i)]
end

Given /^(?:a )?homepages? with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create(:homepage, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @homepage = Homepage.all[rand(Homepage.count.to_i)]
end