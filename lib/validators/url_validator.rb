class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !valid_uri?(value)
      record.errors[attribute].push "is not a valid url. Be sure to include 'http://'."
    end
  end

  #---------------

  private

  def valid_uri?(value)
    begin
      URI.parse(URI.encode(value)).kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
    end
  end
end
