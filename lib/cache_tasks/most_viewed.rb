module CacheTasks
  class MostViewed < Task
    require 'oauth2'

    #---------------

    GA_OPTIONS = {
      "ids"         => "ga:1028848",
      "metrics"     => "ga:pageviews",
      "dimensions"  => "ga:pagePath",
      "max-results" => "30",
      "filters"     => "ga:pagePath!~/photos/.+$",
      "sort"        => "-ga:pageviews",
      "pp"          => "1"
    }
      
    TOKEN_URL = "http://accounts.google.com/o/oauth2/token"
    AUTH_URL  = "http://accounts.google.com/o/oauth2/auth"
    API_URL   = "https://www.googleapis.com"
    API_PATH  = "/analytics/v3/data/ga"
    
    #---------------
    
    def run
      options = GA_OPTIONS.merge(
        "start-date" => (Date.today - 2),
        "end-date"   => Date.today
      )
      
      data    = self.fetch_data(options)
      content = self.content(data['rows'])
      self.cache(content, "/shared/widgets/cached/most_popular_viewed", "widget/popular_viewed")
    end

    #---------------
    
    attr_accessor :verbose
    
    def initialize(client_id, client_secret, token, refresh_token, options={})
      @client_id     = client_id
      @client_secret = client_secret
      @token         = token
      @refresh_token = refresh_token
      
      @client        = self.client
      @oauth_token   = self.oauth_token
      @connection    = self.connection      
    end

    #---------------

    protected
      def fetch_data(ga_options={})
        resp = @connection.get do |req|
          req.url API_PATH, ga_options
        end
              
        return resp.body
      end
    
      #---------------
    
      def content(rows)
        objects = []

        rows.each do |row|
          if object = ContentBase.obj_by_url(row[0])
            # Prevent duplicates
            if !objects.flatten.include?(object)
              self.log "(#{row[1]}) #{row[0]}"
              objects.push object
            end
          end
        end
        
        objects
      end
    
      #---------------
    
      def client
          OAuth2::Client.new(
          @client_id, 
          @client_secret,
          token_url: TOKEN_URL,
          authorization_url: AUTH_URL
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
    #
  end
end
