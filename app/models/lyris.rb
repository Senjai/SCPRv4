class Lyris
  require 'builder'
  
  def initialize(site_id, password, mlid, alert, attributes={})
    @site_id = site_id
    @password = password
    @mlid = mlid
    @alert = alert
  end
  
  def add_message(alert=nil)
    if alert
      if render_message
        request = send_request('message', 'add') do |body|
          body.DATA 'membership@kpcc.org',        type: "from-email"
          body.DATA '89.3 KPCC',                  type: "from-name"
          body.DATA 'HTML',                       type: "message-format"
          body.DATA @html_message,       type: "message-html"
          body.DATA @text_message,       type: "message-text"
          body.DATA alert.email_subject,          type: "subject"
          body.DATA "UTF-8",                      type: "charset"
          body.DATA "Newsletter/Relationship",    type: "category"
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
      else
        puts "Error: Templates could not be rendered."
        return false
      end
    else
      puts "Error: Can't send an e-mail without an alert."
      return false
    end
  end
  
  def render_message
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view  
      include ApplicationHelper
      include WidgetsHelper  
      include Rails.application.routes.url_helpers
    end

    begin
      html_str = view.render(template: "breaking_news_alerts/email/template.html", locals: { alert: @alert })
      text_str = view.render(template: "breaking_news_alerts/email/template.text", locals: { alert: @alert })
      @html_message = html_str.to_str
      @text_message = text_str.to_str
      if @html_message.present? and @text_message.present?
        return true
      else
        return false
      end
    rescue Exception => e
      puts "Error: #{e.message}"
      return false
    end
  end
  
  def send_message(rule=nil)
    if @message_id and rule
      request = send_request('message', 'schedule') do |body|
        body.MID  @message_id
        body.DATA 'schedule',   type: "action"
        
        if Rails.env == "production"
          # Set the rule (segment) to the passed-in ID
          body.DATA rule,     type: "rule"
          
          # No delivery times, by default the e-mail will be send immediately
          
        elsif Rails.env == "development"
          # Set the rule (segment) to a development list (BR_Test)
          body.DATA rule,     type: "rule"
          
          # To send an e-mail immediately, leave these off. 
          # For development/testing, don't want to risk actually sending e-mails,
          # So schedule them for 1 day from now
          future = Time.now + 60*60*24 # One day from now
          #body.DATA future.year,    type: 'delivery-year'
          #body.DATA future.month,   type: 'delivery-month'
          #body.DATA future.day,     type: 'delivery-day'
          #body.DATA '0',            type: 'delivery-hour'
        else
          # Just to be safe for now
          return false
        end
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
      puts "Message not yet added." if @message_id.blank?
      puts "No rule specified! Need segment ID." if rule.blank?
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
