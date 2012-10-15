Feature: Breaking News Alerts

Scenario: Breaking News Alert is present
  Given a breaking news alert with the following attributes:
   | headline             | is_published |
   | Crazy Breaking News! | 1            |
  
  When I go to the home page
  Then I should see breaking news

Scenario: Latest Breaking News Alert is not published
  Given breaking news alerts with the following attributes:
   | headline             | is_published | created_at |
   | Crazy Breaking News! | 0            | today      |
   | Older Breaking News  | 1        | yesterday  |

  When I go to the home page
  Then I should not see breaking news
  
Scenario: Latest Breaking News Alert is not published
  Given breaking news alerts with the following attributes:
   | headline             | is_published | created_at | visible |
   | Older Breaking News  | 1        | yesterday  | 0     |

  When I go to the home page
  Then I should not see breaking news
