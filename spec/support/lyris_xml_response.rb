module LyrisXMLResponse
  require 'builder'
  
  def xml_response(response, data)
    input = ''
    xml = Builder::XmlMarkup.new(target: input)
    xml.DATASET do
      xml.TYPE response
      xml.DATA data
    end
    xml
  end
end