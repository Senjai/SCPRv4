class AddElectionDataPoints < ActiveRecord::Migration
  def up
    group     = "election"
    init_data = "0"
    
    #-------
    DataPoint.create(group: group, data_key: "president:percent_reporting", description: "integer only (no % symbol)", data: init_data)

    DataPoint.create(group: group, data_key: "president:obama_electoral_votes", description: "integer only", data: init_data)
    DataPoint.create(group: group, data_key: "president:romney_electoral_votes", description: "integer only", data: init_data)
    DataPoint.create(group: group, data_key: "president:winner", description: "obama or romney", data: "")


    #-------    
    DataPoint.create(group: group, data_key: "30th:percent_reporting", description: "integer only (no % symbol)", data: init_data)

    DataPoint.create(group: group, data_key: "30th:berman_percent", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "30th:sherman_percent", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "30th:winner", description: "berman or sherman", data: "")

    
    #-------
    DataPoint.create(group: group, data_key: "props:percent_reporting", description: "integer only (no % symbol)", data: init_data)
    
    DataPoint.create(group: group, data_key: "props:30:percent_yes", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:30:percent_no", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:30:passed", description: "true or false", data: "")
    
    DataPoint.create(group: group, data_key: "props:34:percent_yes", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:34:percent_no", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:34:passed", description: "true or false", data: "")
    
    DataPoint.create(group: group, data_key: "props:36:percent_yes", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:36:percent_no", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:36:passed", description: "true or false", data: "")
    
    DataPoint.create(group: group, data_key: "props:38:percent_yes", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:38:percent_no", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "props:38:passed", description: "true or false", data: "")


    #-------    
    DataPoint.create(group: group, data_key: "da:percent_reporting", description: "integer only (no % symbol)", data: init_data)
    
    DataPoint.create(group: group, data_key: "da:lacey_percent", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "da:jackson_percent", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "da:winner", description: "lacey or jackson", data: "")
    
    
    #-------
    DataPoint.create(group: group, data_key: "measures:percent_reporting", description: "integer only (no % symbol)", data: init_data)
    
    DataPoint.create(group: group, data_key: "measures:J:percent_yes", description: "integer only (no % symbol)", data: init_data)
    DataPoint.create(group: group, data_key: "measures:J:percent_no", data: init_data)
    DataPoint.create(group: group, data_key: "measures:J:passed", description: "true or false", data: "")
  end

  def down
  end
end
