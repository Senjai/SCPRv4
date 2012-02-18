Feature: Videos
	In order for Videos to be featured around the website
	An Admin
	Should be able to post videos to the website

Scenario: Display the latest video
	Given there are 4 videos
	When I go to the video index page
	Then I should see the latest video featured

Scenario: Display a single video with valid url
	Given there is 1 video
	When I go to that video's page
	Then I should see that video's information
