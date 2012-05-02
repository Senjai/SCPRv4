# run through script/rails runner

require 'oauth2'

CLIENT_ID     = "105755893782-3lj6feuggf35grqjkira2sbtjkjr3kke.apps.googleusercontent.com"
CLIENT_SECRET = "C1hlt9FIb9XDK1nDw-Hr1bmx"
#TOKEN         = "4/JurB6fCA_qbmGGBPe2DesUzk4_u1"

TOKEN           = "ya29.AHES6ZRNHoI6acq8LRWMxPG3_e3lFf2aCPVcwWF0puyKdiHxD5wabQ"
REFRESH_TOKEN   = "1/7J3KtCVG9jXnQNmkzYk1QoqJlZrbQ0_sinb21MwSUC8"

GA_PROPERTY     = "ga:1028848"

# -- Set up Python Caching -- #

require "rubypython"

# FIXME: Hardcoding production python path for now, but this should be fixed
if Rails.env == "production"
  RubyPython.start(:python_exe => "/usr/local/python2.7.2/bin/python")
else
  RubyPython.start()      
end
    
pickle = RubyPython.import("cPickle")

# -- Initialize our view for rendering -- #

view = ActionView::Base.new(ActionController::Base.view_paths, {})  
   
class << view  
  include ApplicationHelper  
end

# -- Build OAuth2 Token -- #

client = OAuth2::Client.new(CLIENT_ID,CLIENT_SECRET,
  :token_url          => "http://accounts.google.com/o/oauth2/token",
  :authorization_url  => "http://accounts.google.com/o/oauth2/auth"
)

token = OAuth2::AccessToken.new client, TOKEN, :refresh_token => REFRESH_TOKEN
token = token.refresh!

puts token.token

# -- Connect to Google Analytics -- #

# set up our connection
conn = Faraday.new "https://www.googleapis.com", :headers => { :Authorization => "Bearer #{token.token}"} do |builder|
  builder.use Faraday::Request::UrlEncoded
  builder.use Faraday::Response::Logger
  builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
  builder.adapter Faraday.default_adapter
end

# we want the last 2 days
end_date    = Date.today
start_date  = end_date - 2

# make our request
resp = conn.get do |req|
  req.url "/analytics/v3/data/ga", {
    "ids"         => GA_PROPERTY,
    "metrics"     => "ga:pageviews",
    "dimensions"  => "ga:pagePath",
    "max-results" => "30",
    "sort"        => "-ga:pageviews",
    "pp"          => "1",
    "start-date"  => start_date.to_s,
    "end-date"    => end_date.to_s
}
end

rows = resp.body['rows']

# Each row will be [ "URL", "page views" ]

content = []

rows.each do |row|
  # check whether row[0] is a content URL
  if content.length < 5 && obj = ContentBase.obj_by_url(row[0])
    # yes... add it
    content << [ row[1], obj ]
  end
end

# -- Write Caches -- #

top_traffic = view.render(:partial => "shared/widgets/most_popular_viewed", :object => content, :as => :content)
Rails.cache.write("widget/popular_viewed",top_traffic)

# write mercer cache

(Rails.cache.instance_variable_get :@data).set(
  ':1:most_popular:viewed',
  pickle.dumps(top_traffic),
  :raw => true
)






