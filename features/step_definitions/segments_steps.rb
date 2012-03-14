#### Setup
Given /^the program has (\d+) segments?$/ do |num|
  @segments = create_list :show_segment, num.to_i, show: @program, asset_count: 1
  @segment = @segments[rand(@segments.length)]
end

Given /^(?:each|the) episode has (\d+) segments?$/ do |num|
  @program.episodes.each do |episode|
    segments = create_list :show_segment, num.to_i, asset_count: 1, show: @program
    segments.each do |segment|
      create :show_rundown, episode: episode, segment: segment
    end
  end
end

Given /^the segment has (\d+) backward related articles?$/ do |num|
  @related = create_list :brel, num.to_i, content: @segment
end

Given /^the segment has (\d+) forward related articles?$/ do |num|
  @related = create_list :frel, num.to_i, related: @segment
end

Given /^the segment has (\d+) related links?$/ do |num| 
  @links = create_list :link, num.to_i, content: @segment 
end


#### Finders
Then /^I should see each segment's primary asset$/ do
  page.should have_css ".segment-teaser .contentasset img"
end

Then /^I should see the segment's primary asset$/ do
  page.should have_css ".segment .contentasset img"
end

Then /^I should see the segment's information$/ do
  page.find("h1.story-title").should have_content @segment.headline
end

Then /^I should see article meta for the segment$/ do
  page.should have_css ".article-meta", count: 1
end

Then /^I should see a list of segments$/ do
  page.should have_css ".segment-teaser"
end

Then /^I should see a list of that program's segments$/ do
  page.should have_css ".segment-teaser", count: @program.segments.count
end

Then /^I should see a list of that episode's segments$/ do
  page.should have_css ".segment-teaser", count: @episode.segments.count
end

Then /^I should see a list of older segments below the current episode$/ do
  page.should have_css ".show-segments"
  page.should have_content ".segment-teaser", count: @program.segments.count - @program.episodes.published.last.segments.count # TODO Test pagination
end

Then /^only the published segments should be displayed$/ do
  @unpublished_segments = create_list :show_segment, 3, status: 4
  @unpublished_segments.each do |segment|
    create_list :show_rundown, 3, episode: @episode, segment: segment
  end
  page.should have_css ".segment-teaser", count: @episode.segments.published.count
  page.should_not have_content @unpublished_segments.first.headline
end

Then /^the segments should be ordered by the segment order$/ do
  page.first(".segment-teaser").should have_content @episode.segments.published.first.headline
end 


#### Routing
When /^I go to that segment's page$/ do
  visit @segment.link_path
  current_path.should eq @segment.link_path
end


