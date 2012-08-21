#---------------
# Setup

Given /^(?:a? )?pij quer(?:ies|y) with the following attributes?:$/ do |table|
  @pij_queries = []
  table.hashes.each do |attributes|
    if attributes["published_at"].present?
      attributes["published_at"] = Chronic.parse(attributes["published_at"])
    end
    
    if attributes["expires_at"].present?
      attributes["expires_at"] = Chronic.parse(attributes["expires_at"])
    end
    
    @pij_queries.push create(:pij_query, Rack::Utils.parse_nested_query(attributes.to_query))
  end
  @pij_query = PijQuery.all[rand(@pij_queries.size.to_i)]
end


#---------------
# Routing

When /^I go to the pij queries page$/ do
  visit pij_queries_path
end

When /^I go to that pij query's page$/ do
  visit pij_query_path(@pij_query.slug)
end
