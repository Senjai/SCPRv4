module ContentBaseHelpers
  
  def make_content # Creates 5 of each ContentBase subclass for helping with Sphinx tests
    ContentBase.content_classes.each do |klass|
      FactoryGirl.create_list klass.to_s.underscore.to_sym, 15
    end
  end
end

# require './spec/spec_helper.rb'
# require './spec/support/content_base_helpers.rb'
# include ContentBaseHelpers
# ThinkingSphinx::Test.index
# ThinkingSphinx::Test.start