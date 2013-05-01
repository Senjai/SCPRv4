class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  ALERT_TYPES = {
    "break"   => "Breaking News",
    "audio"   => "Listen Live",
    "now"     => "Happening Now"
  }
  
  #-------------------
  # Scopes
  scope :published, -> { order("created_at desc").where(is_published: true) }
  scope :visible,   -> { where(visible: true) }
  
  #-------------------
  # Associations
  
  #-------------------
  # Validations
  
  #-------------------
  # Callbacks
  after_save :async_publish_email, if: :should_send_email?
  after_save :expire_cache

  #-------------------
  # Sphinx  
  define_index do
    indexes headline
    indexes alert_type
    indexes teaser
    has created_at
  end
  
  #-------------------
  
  class << self
    def latest_alert
      alert = self.order("created_at desc").first
      if alert.present? and alert.is_published and alert.visible
        alert
      else
        nil
      end
    end

    def types_select_collection
      ALERT_TYPES.map { |k, v| [v, k] }
    end

    def eloqua_config
      @eloqua_config ||= Rails.application.config.api['eloqua']['attributes']
    end
  end

  #-------------------

  def expire_cache
    Rails.cache.expire_obj("layout/breaking_news_alert")
  end
  
  #-------------------
  # Queue the e-mail sending task so that it doesn't have to
  # occur during an HTTP request.
  def async_publish_email
    Resque.enqueue(Job::BreakingNewsEmail, self.id)
  end

  #-------------------
  # Send the e-mail
  def publish_email
    if should_send_email?
      email = Eloqua::Email.create(
        :folderId         => self.class.eloqua_config['email_folder_id'],
        :emailGroupId     => self.class.eloqua_config['email_group_id'],
        :senderName       => "89.3 KPCC",
        :senderEmail      => "no-reply@kpcc.org",
        :replyToName      => "89.3 KPCC",
        :replyToEmail     => "no-reply@kpcc.org",
        :isTracked        => true,
        :name             => email_name,
        :description      => email_description,
        :subject          => email_subject,
        :isPlainTextEditable => true,
        :plainText        => email_plain_text_body,
        :htmlContent      => {
          :type => "RawHtmlContent",
          :html => email_html_body
        }
      )
      
      campaign = Eloqua::Campaign.create(
        {
          :folderId         => self.class.eloqua_config['campaign_folder_id'],
          :name             => email_name,
          :description      => email_description,
          :startAt          => Time.now.yesterday.to_i,
          :endAt            => Time.now.tomorrow.to_i,
          :elements         => [
            {
              :type           => "CampaignSegment",
              :id             => "-980",
              :name           => "Segment Members",
              :segmentId      => self.class.eloqua_config['segment_id'],
              :position       => {
                :type => "Position",
                :x    => 17,
                :y    => 14
              },
              :outputTerminals => [
                {
                  :type          => "CampaignOutputTerminal", 
                  :id            => "-981",
                  :connectedId   => "-990", 
                  :connectedType => "CampaignEmail", 
                  :terminalType  => "out"
                }
              ]
            },
            { 
              :type             => "CampaignEmail",
              :id               => "-990",
              :emailId          => email.id,
              :sendTimePeriod   => "sendAllEmailAtOnce",
              :position       => {
                :type => "Position",
                :x    => 17,
                :y    => 120
              },
            }
          ]
        }
      )
      
      if campaign.activate
        self.update_column(:email_sent, true)
      end
    end
  end
  
  add_transaction_tracer :publish_email, category: :task
  
  #-------------------
  
  def break_type
    ALERT_TYPES[alert_type]
  end
  
  #-------------------

  def email_html_body
    @email_html_body ||= view.render_view(template: "/breaking_news/email/template", formats: [:html], locals: { alert: self }).to_s
  end

  def email_plain_text_body
    @email_plain_text_body ||= view.render_view(template: "/breaking_news/email/template", formats: [:text], locals: { alert: self }).to_s
  end

  def email_name
    @email_name ||= "[scpr-alert] #{self.headline[0..30]}"
  end

  def email_description
    @email_description ||= "SCPR Breaking News Alert\nSent: #{Time.now}\nSubject: #{email_subject}"
  end

  def email_subject
    @email_subject ||= "#{break_type}: #{headline}"
  end

  #-------------------
    
  def should_send_email?
    self.is_published && self.send_email && !self.email_sent
  end


  private

  def view
    @view ||= CacheController.new
  end
end
