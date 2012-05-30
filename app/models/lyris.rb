class Lyris
  require 'builder'
  
  LYRIS_API = API_KEYS["lyris"]
  API_ENDPOINT = "https://#{LYRIS_API["api_host"]}#{LYRIS_API["api_path"]}"
    
  def initialize(alert)
    @site_id = LYRIS_API["site_id"]
    @password = LYRIS_API["password"]
    @mlid = LYRIS_API["mlid"]
    @alert = alert
  end
  
  def add_message
    input = generate_input do |body|
      body.DATA LYRIS_API["from_email"],      type: "from-email"
      body.DATA LYRIS_API["from_name"],       type: "from-name"
      body.DATA 'HTML',                       type: "message-format"
      body.DATA render_message("html"),       type: "message-html"
      body.DATA render_message("text"),       type: "message-text"
      body.DATA @alert.email_subject,         type: "subject"
      body.DATA "UTF-8",                      type: "charset"
      body.DATA LYRIS_API["category"],        type: "category"
    end
    
    @message_id = send_request('message', 'add', input)
  end
  
  def render_message(format)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view  
      include ApplicationHelper
      include WidgetsHelper  
      include Rails.application.routes.url_helpers
    end
    
    view.render(template: "breaking_news_alerts/email/template", formats: [format.to_sym], locals: { alert: @alert }).to_str
  end
  
  def send_message
    input = generate_input do |body|
      body.MID  @message_id
      body.DATA 'schedule', type: "action"
      body.DATA LYRIS_API["segment_id"], type: "rule"
    end
    
    send_request('message', 'schedule', input)
  end

  def generate_input
    input = ''
    xml = Builder::XmlMarkup.new(target: input)
    
    xml.instruct!
    xml.DATASET do
      xml.SITE_ID @site_id
      xml.MLID @mlid
      xml.DATA @password, type: 'extra', id: 'password'
      if block_given?
        yield xml
      end
    end
    
    return input
  end
  
  def send_request(type, activity, input)
    response = connection.start do |http|
      req = Net::HTTP::Post.new(LYRIS_API["api_path"])
      req.set_form_data("activity" => activity, "type" => type, "input" => input)
      http.request(req).body
    end
    
    if response =~ /<TYPE>error<\/TYPE><DATA>(.+?)<\/DATA>/
      return false
    elsif response =~ /<TYPE>success<\/TYPE><DATA>(.+?)<\/DATA>/
      return $~[1]
    end
  end
  
  def connection
    if !@connection
      @connection = Net::HTTP.new(LYRIS_API["api_host"], 443)
      @connection.use_ssl = true
      @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    @connection
  end
end
