module AdminResource
  module ClassMethods
    
    def list_fields
      if !@list_fields
        self.list_fields = column_names.map { |col| [col] }
      end
      @list_fields
    end
    
    def list_fields=(fields=[])
      if fields.present? 
        fields.each do |f|
          f[0] = f[0].to_s

          # Force a hash into the array if one wasn't given,
          # and then reverse-merge some default values.
          f.push({}) if !f[1]
          f[1].symbolize_keys!

          # Merge in default options
          f[1].reverse_merge!(title: f[0].titleize)
        end

        # The first column will be linked if no link is specified
        if !fields.any? { |f| f[1][:link] == true }
          fields[0][1].merge!(link: true)
        end
      end
      
      @list_fields = fields
    end
    
    # -----------------------
    
    def fields
      if only_fields.present?
        only_fields
      elsif excluded_fields.present?
        column_names - excluded_fields
      else
        column_names - DEFAULTS[:excluded_fields]
      end
    end
    
    # -----------------------

    attr_accessor :excluded_fields, :only_fields
  end
end
