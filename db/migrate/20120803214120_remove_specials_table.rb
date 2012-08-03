class RemoveSpecialsTable < ActiveRecord::Migration
  def up
    drop_table "specials_page"
    
    drop_table "friends_card_discount"
    
    drop_table "jackson_photo"
    
    drop_table "election_candidate"
    drop_table "election_measure"
    drop_table "election_race"
    drop_table "election_tweetqueue"
    
    drop_table "fires_dashboard"
    drop_table "fires_dashboard_feeds"
    drop_table "fires_feed"
    
    drop_table "general_election_candidate"
    drop_table "general_election_coverage"
    drop_table "general_election_profile"
    drop_table "general_election_proposition"
    drop_table "general_election_race"
    
    drop_table "primary_candidate"
    drop_table "primary_proposition"
    drop_table "primary_race"
  end

  def down
  end
end
