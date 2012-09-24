module FormFillers
  def fill_required_fields_with_attributes_from(record)
    class_str = record.class.to_s.underscore
    record.attributes.keys.each do |attrib|
      field_id = "#{class_str}_#{attrib}"
      if record.class.validators_on(attrib).map(&:class).include? ActiveModel::Validations::PresenceValidator
        # Some fields will be drop-downs
        if attrib == "status"
          select ContentBase::STATUS_TEXT[record.send(attrib)], from: field_id
        else
          fill_in field_id, with: record.send(attrib)
        end
      end
    end
  end
end