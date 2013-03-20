module ReplacedAttribute
  def replaced_attribute(old_attribute, options={})
    new_attribute = options[:with]
    
    define_method old_attribute do
      send new_attribute
    end

    define_method "#{old_attribute}=" do |val|
      send "#{new_attribute}=", val
    end
  end
end

ActiveRecord::Base.send :extend, ReplacedAttribute
