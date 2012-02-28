Feature: Videos
	In order for Videos to be featured around the website
	An Admin
	Should be able to post videos to the website

Scenario: Display the latest video shell
	Given there are 4 video shells
	When I go to the video index page
	Then I should see the most recently published video featured