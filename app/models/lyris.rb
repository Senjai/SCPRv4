class Lyris
  require 'builder'
  
  LYRIS_API = API_KEYS["lyris"]
  API_ENDPOINT = "https://#{LYRIS_API["api_host"]}#{LYRIS_API["api_path"]}"
  
  attr_reader :message_id
  
  def initialize(alert)
    @site_id = LYRIS_API["site_id"]
    @password = LYRIS_API["password"]
    @mlid = LYRIS_API["mlid"]
    @alert = alert
  end
  
  def add_message
    render_message("html", "text")
    @message_id = send_request('message', 'add') do |body|
      body.DATA 'membership@kpcc.org',        type: "from-email"
      body.DATA '89.3 KPCC',                  type: "from-name"
      body.DATA 'HTML',                       type: "message-format"
      body.DATA @html_message,                type: "message-html"
      body.DATA @text_message,                type: "message-text"
      body.DATA @alert.email_subject,         type: "subject"
      body.DATA "UTF-8",                      type: "charset"
      body.DATA "Newsletter/Relationship",    type: "category"
    end
  end
  
  def render_message(*message_formats)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view  
      include ApplicationHelper
      include WidgetsHelper  
      include Rails.application.routes.url_helpers
    end
    
    [message_formats].flatten.each do |format|
      message = view.render(template: "breaking_news_alerts/email/template", format: format, locals: { alert: @alert })
      instance_variable_set "@#{format}_message", message.to_str
    end
  end
  
  def send_message
    send_request('message', 'schedule') do |body|
      body.MID  @message_id
      body.DATA 'schedule', type: "action"
      body.DATA API_KEYS["lyris"]["segment_id"], type: "rule"
    end
  end

  def send_request(type, activity)
    input = ''
    xml = Builder::XmlMarkup.new(target: input)
    xml.instruct!
    xml.DATASET do
      xml.SITE_ID @site_id
      xml.MLID @mlid
      xml.DATA @password, type: 'extra', id: 'password'
      yield xml
    end
    
    @response = connection.start do |http|
      req = Net::HTTP::Post.new(API_KEYS["lyris"]["api_path"])
      req.set_form_data("activity" => activity, "type" => type, "input" => input)
      http.request(req).body
    end
    
    if @response =~ /<TYPE>error<\/TYPE><DATA>(.+?)<\/DATA>/
      puts "Error: #{$~[1]}"
      return false
    elsif @response =~ /<TYPE>success<\/TYPE><DATA>(.+?)<\/DATA>/
      @response_data = $~[1]
      puts "Success: #{@response_data}"
      return @response_data
    end
  end
  
  def connection
    if !@connection
      @connection = Net::HTTP.new(API_KEYS["lyris"]["api_host"], 443)
      @connection.use_ssl = true
      @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    @connection
  end
end
