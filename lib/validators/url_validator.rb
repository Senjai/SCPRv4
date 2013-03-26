# URL Validation for ActiveModel
#
# Options
#
# * allowed - An array of allowed URI classes (default: [URI::HTTP])
# * All standard validation options (eg. :message, :allow_blank) 
#
# Examples
#
#    validates :twitter_url, url: true
#
# Notes
#
# * URIs are encoded before they're validated. Therefore, you
# should never allow `URI::Generic`, because it will accept *any* string
# that has been URI-encoded. eg, `URI.parse(URI.encode('#####'))` would
# be considered valid.
#
# * Inheritance is honored when checking if a URI is one of the allowed
# classes. So, if you allow URI::HTTP, then you are also allowing URI::HTTPS.
#
class UrlValidator < ActiveModel::EachValidator
  DEFAULT_MESSAGE = "is not a valid url. Include a valid protocol, such as 'http://'."
  DEFAULT_ALLOWED_CLASSES = [URI::HTTP]

  def validate_each(record, attribute, value)
    if !valid_uri?(value)
      record.errors[attribute].push options[:message] || DEFAULT_MESSAGE
    end
  end

  #---------------

  private

  def valid_uri?(value)
    begin
      uri       = URI.parse(URI.encode(value.to_s))
      allowed   = options[:allowed] || DEFAULT_ALLOWED_CLASSES
      allowed.any? { |klass| uri.is_a?(klass) }
    rescue URI::Error
      false
    end
  end
end
