class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
  has_secretary
  
  ALERT_TYPES = {
    "break"   => "Breaking News",
    "audio"   => "Listen Live",
    "now"     => "Happening Now"
  }
  
  # These ID's are hard-coded from Eloqua.
  # We *could* search for them on every request,
  # but it would take like 10 times longer and these
  # are unlikely to change often.
  ELOQUA_DEFAULTS = {
    :header_id            => 10,   # SCPR 20130122 Breaking News Alert Header
    :footer_id            => 61,   # SCPR 20130122 Breaking News Alert Footer
    :email_group_id       => 69,   # SCPR - Breaking News Alerts
    :campaign_folder_id   => 1229, # Campaings/SCPR/Breaking News Alerts
    :email_folder_id      => 1235, # Emails/SCPR/Breaking News Alerts
    :segment_id           => 194,  # SCPR - Breaking News Alerts Segment
    :campaign_template_id => 28,   # SCPR - Breaking News Alert Campaign Template
    :email_template_id    => 29    # SCPR - Breaking News Alert E-mail Template
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
  after_save :async_send_email, if: :should_send_email?
  after_save :expire_cache
  
  #-------------------
  # Administration
  administrate do
    define_list do
      column :headline
      column :alert_type, display: proc { BreakingNewsAlert::ALERT_TYPES[self.alert_type] }
      column :visible
      column :is_published
      column :email_sent
    end
  end
  
  #-------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes alert_type
    indexes teaser
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
  end

  #-------------------

  def expire_cache
    Rails.cache.expire_obj("layout/breaking_news_alert")
  end
  
  #-------------------
  # Queue the e-mail sending task so that it doesn't have to
  # occur during an HTTP request.
  def async_send_email
    Resque.enqueue(Job::BreakingNewsEmail, self.id)
  end

  #-------------------
  # Send the e-mail
  def publish_email
    if should_send_email?
      client = Eloqua::Client.new(API_KEYS['eloqua'])
      
      description = "SCPR Breaking News Alert\nSent: #{Time.now}\nSubject: #{email_subject}"
      view = CacheController.new
      
      email = Eloqua::Email.create(
        :folderId         => ELOQUA_DEFAULTS[:email_folder_id],
        :emailGroupId     => ELOQUA_DEFAULTS[:email_group_id],
        :senderName       => "89.3 KPCC",
        :senderEmail      => "no-reply@kpcc.org",
        :name             => email_subject,
        :description      => description,
        :subject          => email_subject,
        :isPlainTextEditable => true,
        :sendPlainTextOnly => true,
        :plainText        => view.render_view(template: "/breaking_news/email/template", formats: [:text], locals: { alert: self }).to_s,
        :htmlContent      => {
          :type => "RawHtmlContent",
          :html => view.render_view(template: "/breaking_news/email/template", formats: [:html], locals: { alert: self }).to_s
        }
      )
      
      campaign = Eloqua::Campaign.create(
        {
          :folderId         => ELOQUA_DEFAULTS[:campaign_folder_id],
          :name             => email_subject,
          :description      => description,
          :startAt          => Time.now.to_i,
          :endAt            => Time.now.to_i,
          :elements         => [
            {
              :type           => "CampaignSegment",
              :id             => "-980",
              :name           => "Segment Members",
              :segmentId      => ELOQUA_DEFAULTS[:segment_id],
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
      
      campaign.activate
      
      self.update_column(:email_sent, true)
    end
  end
  
  #-------------------
  
  def break_type
    ALERT_TYPES[alert_type]
  end
  
  #-------------------

  def email_subject
    @email_subject ||= "#{break_type}: #{headline}"
  end

  #-------------------
  
  private
  
  def should_send_email?
    self.is_published && self.send_email && !self.email_sent
  end
end
