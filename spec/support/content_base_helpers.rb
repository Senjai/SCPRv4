module ContentBaseHelpers
  def make_content(num=5) # Creates `num` of each ContentBase subclass for helping with Sphinx tests
    records = []
    ContentBase.content_classes.each do |klass|
      records += FactoryGirl.create_list(klass.to_s.underscore.to_sym, num.to_i, with_category: true)
    end
    records
  end
end

# require './spec/spec_helper.rb'
# require './spec/support/content_base_helpers.rb'
# include ContentBaseHelpers

# -- Example usage for ThinkingSphinx::Test

# before :each do
#   DatabaseCleaner.strategy = :truncation
#   ThinkingSphinx::Test.index
#   ThinkingSphinx::Test.start
# end

# after :each do
#   ThinkingSphinx::Test.stop
#   DatabaseCleaner.strategy = :transaction
# end