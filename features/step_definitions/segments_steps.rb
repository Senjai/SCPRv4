#### Setup
Given /^the program has (\d+) segments?$/ do |num|
  @segments = create_list :show_segment, num.to_i, show: @program, asset_count: 1
  @segment = @segments[rand(@segments.length)]
end

Given /^there (?:is|are) (\d+) segments?$/ do |num|
  @segments = create_list :show_segment, num.to_i
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


#### Finders
Then /^I should see each segment's primary asset$/ do
  page.should have_css ".teaser .contentasset img", count: ShowSegment.count
end

Then /^I should see the segment's primary asset$/ do
  page.should have_css ".segment .contentasset img", count: 1
end

Then /^I should see the segment's information$/ do
  page.find(".segment article header").should have_content ShowSegment.last.headline
end

Then /^I should see a list of that program's segments$/ do
  page.should have_css ".teaser", count: @program.segments.count
end

Then /^I should see a list of that episode's segments$/ do
  page.should have_css ".teaser", count: ShowEpisode.last.segments.count
end

Then /^I should see a list of older segments below the current episode$/ do
  page.should have_css ".show-segments"
  page.should have_content ".teaser", count: @program.segments.count - @program.episodes.published.last.segments.count # TODO Test pagination
end

Then /^the segments should be ordered by the segment order$/ do
  pending
  page.first(".teaser").should have_content @episode.segments.published.first.headline
end 



#### Assertions
Then /^that section should not have the current segment listed$/ do
  page.find(@css_finder).should_not have_content @segment.headline
end


#### Routing
When /^I go to (?:that|the|a|any) segment's page$/ do
  @segment = ShowSegment.all[rand(ShowSegment.count)]
  visit @segment.link_path
  current_path.should eq @segment.link_path
end

When /^I visit a segment page with an incorrect id$/ do
  visit "/programs/#{@segment.show.slug}/2012/03/27/000/us-navy-developing-soldiers-spidey-sense-intuition/"
end

Then /^I should be on that segment's program page$/ do
  current_path.should eq program_path @segment.show
end
