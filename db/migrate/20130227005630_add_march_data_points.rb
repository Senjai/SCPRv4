class AddMarchDataPoints < ActiveRecord::Migration
  GROUP_NAME = "election-march2013"

  def up
    DataPoint.create([{
      group_name: GROUP_NAME,
      data_key: "percent_reporting",
      notes: "Number only (no % symbol)"
    },{
      group_name: GROUP_NAME,
      data_key: "percent_garcetti",
      notes: "Eric Garcetti; Number only (no % symbol)"
    },{
      group_name: GROUP_NAME,
      data_key: "percent_greuel",
      notes: "Wendy Greuel; Number only (no % symbol)"
    },{
      group_name: GROUP_NAME,
      data_key: "percent_james",
      notes: "Kevin James; Number only (no % symbol)"
    },{
      group_name: GROUP_NAME,
      data_key: "percent_perry",
      notes: "Jan Perry; Number only (no % symbol)"
    },{
      group_name: GROUP_NAME,
      data_key: "percent_pleitez",
      notes: "Emanuel Pleitez; Number only (no % symbol)"
    },{
      group_name: "twitter",
      data_key: "auto_tweet",
      notes: "Boolean. Options: [true, false]"
    },{
      group_name: "twitter",
      data_key: "tweet_append",
      notes: "Text. This will be appended to all auto-tweets."
    }])
  end

  def down
    DataPoint.destroy_all(group_name: [GROUP_NAME, "twitter"])
  end
end
