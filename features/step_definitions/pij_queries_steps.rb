Given /^(?:a? )?pij quer(?:ies|y) with the following attributes?:$/ do |table|
  table.hashes.each do |attributes|
    create(:pij_query, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @pij_query = PijQuery.all[rand(PijQuery.count.to_i)]
end