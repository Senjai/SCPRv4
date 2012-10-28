Feature: PIJ Queries

Scenario: List PIJ Queries
  Given pij queries with the following attributes:
   | headline      | query_type | is_active | published_at |
   | Newsxx        | news       | true      | YESTERDAY    |
   | Evergreenxx   | evergreen  | true      | YESTERDAY    |
   | Internalxx    | utility    | true      | YESTERDAY    |
   | Unpublishedxx | news       | true      | TOMORROW     |
   | Inactivexx    | evergreen  | false     | YESTERDAY    |
  
  When I go to the pij queries page
  Then I should see "Newsxx"
  And I should see "Evergreenxx"
  And I should not see "Internalxx"
  And I should not see "Unpublishedxx"
  And I should not see "Inactivexx"

Scenario: Show a visible PIJ Query
  Given a pij query with the following attributes:
   | headline | body   | query_type | is_active | published_at |
   | Newsxx   | Bodyxx | news       | true      | YESTERDAY    |
  
  When I go to that pij query's page
  Then I should see "Newsxx"
  And I should see "Bodyxx"

Scenario: Show an internal PIJ Query
  Given a pij query with the following attributes:
   | headline   | teaser   | query_type | is_active | published_at |
   | Internalxx | Teaserxx | internal   | true      | YESTERDAY    |
  
  When I go to that pij query's page
  Then I should see "Internalxx"
