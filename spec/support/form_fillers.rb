##
# Form Fillers
#
# Fill in forms with the attributes from a given record
# Also acts as capybara field abstraction
#
module FormFillers
  # Fill all fields, regardless of its validation
  def fill_all_fields(record)
    record.attributes.keys.each do |attribute|
      fill_field(record, attribute)
    end
  end
  
  #------------------
  # Fill only required fields
  def fill_required_fields(record)      
    record.class.validators.select { |v| v.is_a? ActiveModel::Validations::PresenceValidator }.each do |validator|
      validator.attributes.each do |attribute|
        fill_field(record, attribute)
      end
    end
  end
  
  #------------
  
  private
  
    def fill_field(record, attribute)      
      if record.class.reflect_on_association(attribute)
        attribute = "#{attribute}_id"
      end
      
      field_id = "#{record.class.singular_route_key}_#{attribute}"
      
      if page.has_field? field_id
        value = record.send(attribute)
        interact!(field_id, value)
      end
    end
    
    #----------------
    
    def interact!(field_id, value)
      field = find_field(field_id)
      
      case field.tag_name
      when "select"
        text = find("##{field_id} option[value='#{value}']").text
        select text, from: field_id
      
      when "textarea"
        fill_in field_id, with: value
        
      when "input"
        case field[:type]
        when "checkbox"
          value ? check(field_id) : uncheck(field_id)
        
        else
          fill_in field_id, with: value
        end
        
      else
        raise StandardError, "Unexpected field tag_name: #{field.tag_name}"
      end
    end
  #
end
