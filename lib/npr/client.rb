##
# NPR::Client
#
# Basic client for retrieving stories from
# NPR's API.
#
# Argument is a hash of params to send to the API.
# See http://www.npr.org/api/inputReference.php for
# API documentation.
#
# Options passed in when initializing the client will
# go out with every API request. You may also pass in
# options to #query for a per-request basis.
#
# You can also set params via `client.params`
#
# Note that "apiKey" is removed from @params to avoid
# it being accidentally overridden when using `client.params=`
#
# Params should be passed in exactly as they will be sent 
# to the API. Example: "apiKey", not "api_key"
# See the documentation for what those params are.
#
module NPR
  class Client
    attr_accessor :params
    
    def initialize(params={})
      @params  = params
      @api_key = @params.delete(:apiKey)
    end

    #-----------------
    # Send a query to the NPR API.
    # Accepts a hash of options which get passed
    # directly to the API.
    def query(params={})
      response = connection.get do |request|
        request.url NPR::API_PATH
        request.params = @params.merge(params)
        request.params['apiKey'] = @api_key
      end
      
      response.body["nprml"]
    end

    #-----------------
    
    private
    
    #-----------------
    
    def connection
      @connection ||= begin
        Faraday.new NPR::API_ROOT do |conn|
          conn.response :xml, content_type: /\bxml$/
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end # Client
end # NPR
