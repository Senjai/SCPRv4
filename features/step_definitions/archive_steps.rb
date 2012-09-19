Given /^there was some content generated on a past date$/ do
  @date = Chronic.parse("Yesterday at 12pm")
  @news_stories   = create_list :news_story,    3
  @video_shells   = create_list :video_shell,   3
  @content_shells = create_list :content_shell, 3
  @show_segments  = create_list :show_segment,  3
  
  # Do this to reset the published_at date to get around the callback
  NewsStory.update_all     published_at: @date
  VideoShell.update_all    published_at: @date
  ContentShell.update_all  published_at: @date
  ShowSegment.update_all   published_at: @date
  
end

When /^I go to the archive page for that date$/ do
  visit archive_path(date_path @date)
end

Then /^I should see the archived content$/ do
  find("#archive_tabs").should have_content @news_stories.first.short_headline
  find("#archive_tabs").should have_content @content_shells.first.short_headline
  find("#archive_tabs").should have_content @video_shells.first.short_headline
  find("#archive_tabs").should have_content @show_segments.first.short_headline
end

When /^I go to the archive page with no date$/ do
  visit archive_path
end

Then /^I should only see the select form$/ do
  page.should_not have_css "#archive_tabs .tab-pane"
  page.should_not have_css "#archive_tabs .filters"
end

When /^I select a past date from the archive select$/ do
  within "#archive_date_select" do
    select @date.strftime("%Y"),  from: "archive_date_1i" 
    select @date.strftime("%B"),  from: "archive_date_2i"
    select @date.strftime("%-d"), from: "archive_date_3i"
    find("input[type=submit]").click
  end  
end

Then /^I should be on the archive page for that date$/ do
  current_path.should eq archive_path date_path(@date)
end
