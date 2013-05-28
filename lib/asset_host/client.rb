##
# AssetHost::Client
#
module AssetHost
  class Client
    attr_accessor :params
    
    def initialize(params={})
      @params = params
      @auth_token = @params.delete(:auth_token)
    end

    #-----------------
    # Params:
    # * url     - source of the image
    # * hidden  - hide from list in assethost
    # * note    -
    # * owner   -
    # * caption -
    def create(params={})
      response = connection.post do |request|
        request.url "/api/as_asset"
        request.params = @params.merge(params)
        request.params['auth_token'] = @auth_token
        request.headers['Content-Type'] = 'application/json'
      end
      
      response.body
    end

    #-----------------

    private

    #-----------------

    def connection
      @connection ||= begin
        Faraday.new(url: AssetHost::API_ROOT) do |conn|
          conn.response :json
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end # Client
end # AssetHost
