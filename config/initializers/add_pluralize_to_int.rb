class Integer
  def pluralize(term)
    if self == 0
      fc = term[0].codepoints().next
      return "#{(fc >= 65 && fc <= 90) ? "N" : "n"}o #{ActiveSupport::Inflector.pluralize(term)}"
    elsif self == 1
      return "#{self.to_s} #{term}"
    else
      return "#{self.to_s} #{ActiveSupport::Inflector.pluralize(term)}"
    end
  end
end