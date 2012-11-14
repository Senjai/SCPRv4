module CacheTasks
  class MostViewed < Task
    require 'oauth2'

    #---------------
      
    TOKEN_URL = "https://accounts.google.com/o/oauth2/token"
    AUTH_URL  = "https://accounts.google.com/o/oauth2/auth"
    API_URL   = "https://www.googleapis.com"
    API_PATH  = "/analytics/v3/data/ga"
    
    #---------------

    def self.api_params(options={})
      {
        "ids"         => "ga:1028848",
        "metrics"     => "ga:pageviews",
        "dimensions"  => "ga:pagePath",
        "max-results" => "30",
        "filters"     => "ga:pagePath!~/photos/.+$",
        "sort"        => "-ga:pageviews",
        "pp"          => "1",
        "start-date"  => Date.today - 2,
        "end-date"    => Date.today
      }.merge(options)
    end

    #---------------
    
    def run
      data    = self.fetch(MostViewed.api_params)
      content = self.parse(data['rows'])
      self.cache(content, "/shared/widgets/cached/most_popular_viewed", "widget/popular_viewed")
      true
    end

    #---------------
        
    def initialize(client_id, client_secret, token, refresh_token, options={})
      @client_id     = client_id
      @client_secret = client_secret
      @token         = token
      @refresh_token = refresh_token
      
      @client        = client
      @oauth_token   = oauth_token
      @connection    = connection
    end

    #---------------

    def fetch(api_params={})
      resp = @connection.get do |req|
        req.url API_PATH, api_params
      end
      
      resp.body
    end
    
    #---------------
    
    def parse(rows)
      objects = []

      rows.each do |row|
        if object = ContentBase.obj_by_url(row[0])
          self.log "(#{row[1]}) #{row[0]}"
          objects.push object
        end
      end
      
      objects.uniq
    end
    
    #---------------
    
    private
    def client
        OAuth2::Client.new(
          @client_id, 
          @client_secret,
          :authorization_url => AUTH_URL,
          :token_url         => TOKEN_URL
        )
    end
  
    #---------------

    def oauth_token
      token = OAuth2::AccessToken.new @client, @token, refresh_token: @refresh_token
      token.refresh!
    end

    #---------------

    def connection
      Faraday.new API_URL, headers: { "Authorization" => "Bearer #{@oauth_token.token}"} do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::Logger
        builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        builder.adapter Faraday.default_adapter
      end        
    end
  end # MostViewed
end # CacheTasks
