Feature: Blogs

Scenario: List News Blogs
	Given blogs with the following attributes:
	 | is_news |
	 | 1       |
	 | 1       |

	When I go to the blogs page
	Then I should see 2 blogs listed in the News section

Scenario: See latest entry for a local blog
	Given a blog with the following attribute:
	 | entry_count |
	 | 2             |

	When I go to the blogs page
	Then I should see the latest entry for that blog
	
Scenario: See latest entry for a remote blog
	Given a blog with the following attribute:
	 | is_remote |
	 | 1         |
	
	And the entry for it has been cached
	When I go to the blogs page
	Then I should see the latest entry for that remote blog
	And I should see a timestamp for the latest entry

Scenario: Blog Teaser on Blogs Index page
	Given 1 blog
	When I go to the blogs page
	Then I should see that blog's teaser

Scenario: Local Blog
	Given a blog with the following attribute:
	 | entry_count |
	 | 2           |
	
	When I go to that blog's page
	Then I should see the blog's information
	And I should see the blog's entries listed
	And I should see the recent posts widget for that blog
	
Scenario: See time stamps
	Given a blog with the following attribute:
	 | entry_count |
	 | 1           |

	When I go to the blogs page
	Then I should see a timestamp for the latest entry

Scenario: See the blog's missed it bucket if it has one
	Given a blog with the following attributes:
	 | missed_it_bucket[contents_count] |
	 | 3                                |

	When I go to the blog's page
	Then I should see a missed it bucket
	And the missed it bucket should have 3 items in it

Scenario: Do not show a missed it bucket if the blog doesn't have one
	Given a blog with the following attributes:
	 | missed_it_bucket_id |
	 |                     |

	When I go to that blog's page
	Then I should not see a missed it bucket

Scenario: Do not show a missed it bucket if the bucket has no contents
	Given a blog with the following attributes:
	 | missed_it_bucket[contents_count] |
	 | 0                                |

	When I go to that blog's page
	Then I should not see a missed it bucket