##
# Eloqua::Client
#
module Eloqua
  class Client
    #-------------------
    
    def initialize(credentials, options={})
      credentials.symbolize_keys!
      
      @company  = credentials[:company]
      @user     = credentials[:user]
      @password = credentials[:password]
      @url      = Eloqua::BASE_URL
    end

    #----------------------
    
    def fetch_url
      @url = api_urls["rest"]["standard"] if api_urls
    end

    #----------------------
    # Send a get request with the specified parameters.
    #
    # Example:
    #
    #   client.get("/assets/email/header", count: 1)
    #
    def get(path, params={})
      api.get do |request|
        request.url path
        request.params = params
      end
    end

    #----------------------
    # Send a POST request with the specified body
    #
    # Example:
    #
    #   client.post("/assets/email/header", { title: 'Cool Body' })
    #
    def post(path, body={})
      api.post do |request|
        request.url path
        request.headers['Content-Type'] = "application/json"
        request.body = body.to_json
      end
    end

    #----------------------
    # Send a PUT request with the specified body
    #
    # Example:
    #
    #   client.put("/assets/email/header", { title: 'Cool Body' })
    #
    def put(path, body={})
      api.put do |request|
        request.url path
        request.headers['Content-Type'] = "application/json"
        request.body = body.to_json
      end
    end

    #----------------------
    # Send a PUT request with the specified body
    #
    # Example:
    #
    #   client.delete("/assets/email/header/123")
    #
    def delete(path)
      api.delete do |request|
        request.url path
      end
    end
    
    #-----------------
    
    def api
      @api ||= connection(@url)
    end

    #-----------------
    
    private
    
    def connection(url)
      Faraday.new url do |conn|
        conn.basic_auth @company + "\\" + @user, @password
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end

    #-----------------
    
    def api_urls
      @api_urls ||= begin
        response = connection(Eloqua::LOGIN_ROOT).get
        response.success? ? response.body['urls'] : nil
      end
    end
  end
end
