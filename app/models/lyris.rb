class Lyris
  require 'builder'
  attr_reader :site_id, :password, :mlid, :alert, :response
  
  def initialize(site_id, password, mlid, alert, attributes={})
    @site_id = site_id
    @password = password
    @mlid = mlid
    @alert = alert
  end
  
  def add_message
    request = send_request('message', 'add') do |body|
      body.DATA 'membership@kpcc.org',      type: "from-email"
      body.DATA '89.3 KPCC',                type: "from-name"
      body.DATA 'HTML',                     type: "message-format"
      body.DATA "test: html message",       type: "message-html"
      body.DATA "test: text message",       type: "message-text"
      body.DATA "test-subject",             type: "subject"
      body.DATA "UTF-8",                    type: "charset"
      body.DATA "Newsletter/Relationship",  type: "category"
    end
          
    if request
      if @response_data =~ /(\d+)/
        @message_id = $~[1]
        puts "Successfully added message. ID: #{@message_id}"
        return @message_id
      else
        puts "Response does not contain a valid message ID."
        return false
      end
    else
      puts "Error: #{@error}"
      return false
    end
  end
  
  def send_message
    if @message_id
      request = send_request('message', 'schedule') do |body|
        body.MID  @message_id
        body.DATA 'schedule',   type: "action"
        body.DATA '315927',     type: "rule"
        body.DATA '2012',       type: 'delivery-year'
        body.DATA '05',         type: 'delivery-month'
        body.DATA '30',         type: 'delivery-day'
        body.DATA '14',         type: 'delivery-hour'
      end
      
      if request
        if @response_data
          puts "Successfully sent message. Response: #{@response_data}"
          return @message_id
        else
          return @response
        end
      else
        puts "Error: #{@error}"
        return false
      end
        
    else 
      puts "Message not yet added."
      return false
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
    
    conn = Net::HTTP.new(API_KEYS["lyris"]["api_host"], 443)
    conn.use_ssl = true
    conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    @response = conn.start do |http|
      req = Net::HTTP::Post.new(API_KEYS["lyris"]["api_path"])
      req.set_form_data("activity" => activity, "type" => type, "input" => input)
      http.request(req).body
    end
    
    if @response =~ /<TYPE>error<\/TYPE><DATA>(.+?)<\/DATA>/
      @error = $~[1]
      return false
    elsif @response =~ /<TYPE>success<\/TYPE><DATA>(.+?)<\/DATA>/
      return @response_data = $~[1]
    else
      return @response
    end
  end
end
