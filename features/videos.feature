Feature: Videos
	In order for Videos to be features around the website
	An Admin
	Should be able to post videos on the website by themselves

Scenario: Display a single video with valid url
	Given there is 1 video
	When I go to that video's page
	Then the video should be loaded
