Feature: Videos
	In order for Videos to be featured around the website
	An Admin
	Should be able to post videos to the website

Scenario: No Videos
	Given there are 0 video shells
	When I go to the videos page
	Then I should see that there is nothing to list with the message "There are currently no Videos"
	
Scenario: Display the most recently published video shell on the "index" page
	Given there are 4 video shells
	When I go to the videos page
	Then I should see the most recently published video featured

Scenario: Feature a specific video on the "Show" page
	Given there are 2 video shells
	When I go to the page for one of the videos
	Then I should see that video featured

Scenario: Show 4 most recently published videos on index page
	Given there are 5 video shells
	When I go to the videos page
	Then I should see a section with the 4 most recently published videos
	
Scenario: Show 4 most recently published videos on video show page
	Given there are 5 video shells
	When I go to the page for one of the videos
	Then I should see a section with the 4 most recently published videos
	
Scenario: Comments for a video
	Given there is 1 video shell
	When I go to that video's page
	Then I should see a comments section

@javascript
Scenario: Show 9 most recently published videos in the modal pop-up
	Given there are 10 video shells
	When I go to the videos page
	And I click on the Browse All Videos button
	Then I should see the 9 most recently published videos in the pop-up
	And there should be modal pagination
	
	When I click the Next Page button
	Then I should be on page 2 of the videos list
	And I should see different videos than the first page
	
@javascript
Scenario: No videos in modal
	Given there are 0 video shells
	When I go to the videos page
	And I click on the Browse All Videos button
	Then I should see that there is nothing to list in the pop-up with the message "There are currently no Videos"
