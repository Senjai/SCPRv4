class BreakingNewsAlert < ActiveRecord::Base
  self.table_name = 'layout_breakingnewsalert'
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Associations::ContentAlarmAssociation
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

  ALERT_TYPES = {
    "break"   => "Breaking News",
    "audio"   => "Listen Live",
    "now"     => "Happening Now"
  }

  STATUS_DRAFT      = 0
  STATUS_PENDING    = 3
  STATUS_PUBLISHED  = 5

  STATUS_TEXT = {
    STATUS_DRAFT        => "Draft",
    STATUS_PENDING      => "Pending",
    STATUS_PUBLISHED    => "Published"
  }

  PARSE_CHANNEL         = "breakingNews"
  FRAGMENT_EXPIRE_KEY   = "layout/breaking_news_alert"

  #-------------------
  # Scopes
  scope :published, -> {
    where(status: STATUS_PUBLISHED)
    .order("published_at desc")
  }

  scope :visible,   -> { where(visible: true) }

  #-------------------
  # Associations

  #-------------------
  # Validations
  validates :headline, presence: true
  validates :alert_type, presence: true
  validates :alert_url, url: { allow_blank: true }

  #-------------------
  # Callbacks
  after_save :async_send_email,
    :if => :should_send_email?

  after_save :async_send_mobile_notification,
    :if => :should_send_mobile_notification?

  after_commit :expire_alert_fragment

  #-------------------
  # Sphinx
  define_index do
    indexes headline
    indexes alert_type
    indexes teaser
    has published_at
  end

  #-------------------

  class << self
    # Get the latest published alert, whether visible or not,
    # and check if it's visible.
    def latest_alert
      alert = self.published.first
      alert.try(:visible?) ? alert : nil
    end

    def types_select_collection
      ALERT_TYPES.map { |k, v| [v, k] }
    end

    def status_select_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end

    def eloqua_config
      @eloqua_config ||= Rails.application.config.api['eloqua']['attributes']
    end

    def expire_alert_fragment
      Rails.cache.expire_obj(FRAGMENT_EXPIRE_KEY)
    end
  end

  #-------------------

  def published?
    self.status == STATUS_PUBLISHED
  end

  def pending?
    self.status == STATUS_PENDING
  end

  def status_text
    STATUS_TEXT[self.status]
  end

  # Callbacks will handle the email/push notification
  def publish
    self.update_attributes(status: STATUS_PUBLISHED)
  end



  #-------------------
  # Queue the e-mail sending task so that it doesn't have to
  # occur during an HTTP request.
  def async_send_email
    Resque.enqueue(Job::SendBreakingNewsEmail, self.id)
  end

  def async_send_mobile_notification
    Resque.enqueue(Job::SendBreakingNewsMobileNotification, self.id)
  end


  # Publish a mobile notification
  def publish_mobile_notification
    return false if !should_send_mobile_notification?

    push = Parse::Push.new({
      :title      => "KPCC - #{self.break_type}",
      :alert      => self.email_subject,
      :badge      => "Increment",
      :alertId    => self.id
    }, PARSE_CHANNEL)

    result = push.save

    if result["result"] == true
      self.update_column(:mobile_notification_sent, true)
    else
      # TODO: Handle errors from Parse
    end
  end

  add_transaction_tracer :publish_mobile_notification, category: :task


  #-------------------
  # Send the e-mail
  def publish_email
    return false if !should_send_email?

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

  add_transaction_tracer :publish_email, category: :task

  #-------------------

  def break_type
    ALERT_TYPES[alert_type]
  end

  #-------------------

  def email_html_body
    @email_html_body ||= view.render_view(
      :template   => "/breaking_news/email/template",
      :formats    => [:html],
      :locals     => { alert: self }
    ).to_s
  end

  def email_plain_text_body
    @email_plain_text_body ||= view.render_view(
      :template   => "/breaking_news/email/template",
      :formats    => [:text],
      :locals     => { alert: self }
    ).to_s
  end

  def email_name
    @email_name ||= "[scpr-alert] #{self.headline[0..30]}"
  end

  def email_description
    @email_description ||= "SCPR Breaking News Alert\n" \
                           "Sent: #{Time.now}\nSubject: #{email_subject}"
  end

  def email_subject
    @email_subject ||= "#{break_type}: #{headline}"
  end



  private

  def view
    @view ||= CacheController.new
  end

  def should_send_email?
    self.published? &&
    self.send_email? &&
    !self.email_sent?
  end

  def should_send_mobile_notification?
    self.published? &&
    self.send_mobile_notification? &&
    !self.mobile_notification_sent?
  end

  def expire_alert_fragment
    BreakingNewsAlert.expire_alert_fragment
  end
end
