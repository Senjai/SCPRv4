##
# ElectionResults
#
# Simnple task to fetch the JSON feed and update 
# the associated DataPoint objects
#
module CacheTasks
  class ElectionResults < Task
    PROPS = {
      "30" => "Temporary Taxes to Fund Education",
      "34" => "Death Penalty",
      "36" => "Three Strikes Law",
      "38" => "Tax for Education. Early Childhood Programs"
    }
    
    def data_key_map
      return {} if !@data
      
      {
        # 30th Congressional District
        "30th:percent_reporting" => @data["bodies"]["us.house"]["contests"]["U.S. House of Representatives District 30"]["precincts"]["reporting_percent"],
        "30th:berman_percent"    => @data["bodies"]["us.house"]["contests"]["U.S. House of Representatives District 30"]["candidates"]["berman_113"]["vote_percent"],
        "30th:sherman_percent"   => @data["bodies"]["us.house"]["contests"]["U.S. House of Representatives District 30"]["candidates"]["sherman_438"]["vote_percent"],
        
        # Prop Reporting %
        "props:percent_reporting" => @data["bodies"]["ca.propositions"]["contests"][PROPS["30"]]["precincts"]["reporting_percent"],
        
        # Prop 30
        "props:30:percent_yes"       => @data["bodies"]["ca.propositions"]["contests"][PROPS["30"]]["candidates"]["_Yes"]["vote_percent"],
        "props:30:percent_no"        => @data["bodies"]["ca.propositions"]["contests"][PROPS["30"]]["candidates"]["_No"]["vote_percent"],
        
        # Prop 34
        "props:34:percent_yes"       => @data["bodies"]["ca.propositions"]["contests"][PROPS["34"]]["candidates"]["_Yes"]["vote_percent"],
        "props:34:percent_no"        => @data["bodies"]["ca.propositions"]["contests"][PROPS["34"]]["candidates"]["_No"]["vote_percent"],
        
        # Prop 36
        "props:36:percent_yes"       => @data["bodies"]["ca.propositions"]["contests"][PROPS["36"]]["candidates"]["_Yes"]["vote_percent"],
        "props:36:percent_no"        => @data["bodies"]["ca.propositions"]["contests"][PROPS["36"]]["candidates"]["_No"]["vote_percent"],
        
        # Prop 38
        "props:38:percent_yes"       => @data["bodies"]["ca.propositions"]["contests"][PROPS["38"]]["candidates"]["_Yes"]["vote_percent"],
        "props:38:percent_no"        => @data["bodies"]["ca.propositions"]["contests"][PROPS["38"]]["candidates"]["_No"]["vote_percent"]
      }
    end

    #---------------
        
    def run
      self.fetch
      self.update_data
    end
    
    #---------------
    
    def initialize(feed_url)
      @feed       = URI.parse(feed_url)
      @connection = connection
    end

    #---------------
    
    def fetch
      resp = @connection.get do |req|
        req.url @feed.path
      end
      
      @data = resp.body
    end

    #---------------
    
    def update_data
      data_points = DataPoint.where(group: "election")
      data        = DataPoint.to_hash(data_points)
      
      # Now update the stuff
      data_key_map.keys.each do |key|
        data[key].object.update_attribute(:data, data_key_map[key] || "")
      end
    end

    #---------------
    
    private
    def connection
      Faraday.new "#{@feed.scheme}://#{@feed.host}" do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use FaradayMiddleware::ParseJson
        builder.adapter Faraday.default_adapter
      end        
    end
  end # ElectionResults
end # CacheTasks
