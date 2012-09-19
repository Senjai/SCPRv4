##
# Unique By validator
# Makes sure an attribute is unique by a specified day, month, year, etc.
# This validator is heavily based on ActiveRecord::Validations::UniquenessValidator
#
# It uses the `beginning_of_*` and `end_of_*` methods to 
# specify the range of dates for which the attribute must be unique 
# ActiveSupport::CoreExtensions::Date::Calculations
# http://apidock.com/rails/ActiveSupport/CoreExtensions/Date/Calculations
#
# `scope` must be a datetime field
# Filter options are: [:hour, :day, :week, :month, :quarter, :year]
#
# Usage:
#
#   validates :slug, unique_by_date: { scope: :starts_at, filter: :day }
#
class UniqueByDateValidator < ActiveModel::EachValidator
  def setup(klass)
    @klass = klass
  end
  
  #---------------
  
  def validate_each(record, attribute, value)
    finder_class = find_finder_class_for(record)
    table        = finder_class.arel_table

    coder = record.class.serialized_attributes[attribute.to_s]

    if value && coder
      value = coder.dump value
    end
    
    relation = table[attribute].eq(value)
    relation = relation.and(table[finder_class.primary_key.to_sym].not_eq(record.send(:id))) if record.persisted?
    
    scope_value = record.read_attribute(options[:scope])
    return true if !scope_value
    
    low_limit  = scope_value.send("beginning_of_#{options[:filter]}")
    high_limit = scope_value.send("end_of_#{options[:filter]}")
    
    relation = relation.and(table[options[:scope]].gteq(low_limit))
    relation = relation.and(table[options[:scope]].lt(high_limit))
    relation = finder_class.unscoped.where(relation)
    
    if relation.exists?
      record.errors.add(attribute, :taken, options.merge(value: value))
    end
  end

  #---------------
  
  protected
    def find_finder_class_for(record) #:nodoc:
      class_hierarchy = [record.class]

      while class_hierarchy.first != @klass
        class_hierarchy.prepend(class_hierarchy.first.superclass)
      end

      class_hierarchy.detect { |klass| !klass.abstract_class? }
    end
  #
end
