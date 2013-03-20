class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !valid_uri?(value)
      record.errors[attribute].push "is not a valid url. Be sure to include a valid protocol, such as 'http://'."
    end
  end

  #---------------

  private

  def valid_uri?(value)
    begin
      uri = URI.parse(URI.encode(value))
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::FTP)
    rescue URI::Error
      false
    end
  end
end
