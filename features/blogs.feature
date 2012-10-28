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
   | 2           |

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

Scenario: Local Blog
  Given a blog with the following attribute:
   | entry_count |
   | 2           |
  
  When I go to that blog's page
  Then I should see the blog's information
  And I should see the blog's entries listed
