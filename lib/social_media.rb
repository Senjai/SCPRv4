VIDEO_TEMPLATE = '<iframe src="http://player.vimeo.com/video/%s?byline=0&amp;portrait=0" width="%s" height="%s" frameborder="0"></iframe>'

def scale_height(initial_width, initial_height, resized_width=620):
    """
    Return modified height given original dimensions & resized width.
    """
    return (int(resized_width) * int(initial_height))/int(initial_width)


def get_vimeo_data(user_id):
  conn = Faraday.new "http://vimeo.com", :headers => { 'User-Agent', 'mercer/1.0 +http://www.scpr.org' } do |builder|
    builder.use Faraday::Request::UrlEncoded
    builder.use Faraday::Response::Logger
    builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
    builder.adapter Faraday.default_adapter
  end

  resp = conn.get do |req|
    req.url "/api/v2/#{user_id}/videos.json"
  end
  
  rows = resp.body['rows']
end

def video_list_for_user(user_id, video_width, count)
    unless html = Rails.cache.get("vimeo:templatetag:video-for-user:#{user_id}:width:#{video_width}")
      response = get_vimeo_data("user_id")
        try:
            results = json.loads(response)
            videos = results[:count]
            
            video_list = []
            
            for video in videos:
                video_id = video["id"]
                original_height = video["height"]
                original_width = video["width"]
                video_height = scale_height(original_width, original_height, video_width)
                html = "<li>" + VIDEO_TEMPLATE % (video_id, video_width, video_height) + "</li>"
                video_list.append(html)
            
            video_html = "<ul class='vimeo-list'>" + "\n".join(video_list) + "</ul>"
            
            # if exists, set video to embed html and timeout to 30 min                
            timeout = 60*30
        except:
            # if error, set video to NO-VIDEO string and timeout to 5 min
            video_html = "NO-VIDEO"
            timeout = 60*5
            cache.set(key, html, timeout)
    if video_html == "NO-VIDEO":
        video_html = None
    return video_html

PHOTO_TEMPLATE = '<a href="%s"><img src="%s" /></a>'

def photo_list(count):
    key = "flickr:templatetag:photos-for-scpr:medium"
    html = cache.get(key)
    if not html:
        try:
            flickr = flickrapi.FlickrAPI(settings.FLICKR_API_KEY, format='xmlnode')
            response = flickr.people_getPublicPhotos(user_id='23176711@N07')
    
            photo_list = []
    
            for photo in response.photos[0].photo[:count]:
                medium_source = "http://farm%s.static.flickr.com/%s/%s_%s.jpg" % (photo['farm'], photo['server'], photo['id'], photo['secret'])
                source_url = "http://www.flickr.com/photos/scpr/%s" % photo['id']
                html = "<li>" + PHOTO_TEMPLATE % (source_url, medium_source)
                photo_list.append(html)
    
            photo_html = "<ul class='flickr-list'>" + "\n".join(photo_list) + "</ul>"
    
            timeout = 60*30
        except:
            photo_html = "NO-PHOTOS"
            timeout = 60*5
            cache.set(key, html, timeout)
    if photo_html == "NO-PHOTOS":
        photo_html = None
    return photo_html
    


@register.simple_tag
def sm_videos(count=5):
    return video_list_for_user('kpcc', 300, count)

@register.simple_tag
def sm_photos(count=5):
    return photo_list(count)