##
# Usage:
#
# Add to spec_helper:
#
#     require './spec/support/thinking_sphinx_helpers.rb'
#     config.include ThinkingSphinxHelpers
#
#
# Example usage with ThinkingSphinx::Test
#
# There is a wrapper method to put anywhere:
#
#     describe "GET /index" do
#       sphinx_spec(num: 2)
#
#       it "assigns @content" do
#         # ...
#       end
#
#
# Or you can use make_content directly if you need
# more control. sphinx_spec hijacks before(:all)
# and after(:all), so if you need more inside use this 
# method.
# 
#    before :all do
#      DatabaseCleaner.strategy = :truncation, { except: STATIC_TABLES }
#      make_content(7)
#      ThinkingSphinx::Test.start
#    end
#     
#    after :all do
#      ThinkingSphinx::Test.stop
#      DatabaseCleaner.strategy = :transaction
#    end
#
# `make_content` assigns @generated_content for you, available for using in your specs. 

module ThinkingSphinxHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  # Creates `num` of each ContentBase subclass for 
  # helping with Sphinx tests
  def make_content(num = nil, options=nil)
    num     ||= 5
    options ||= {}
    
    @generated_content = []
    ContentBase.content_classes.each do |klass|
      @generated_content.push FactoryGirl.create_list(
        klass.to_s.underscore.to_sym, num.to_i, options.reverse_merge!(with_category: true)
      )
    end
    
    @generated_content = @generated_content.flatten
  end
  
  # -----------
  
  def setup_sphinx
    DatabaseCleaner.strategy = :truncation, { except: STATIC_TABLES }
  end
  
  # -----------

  def index_sphinx
    ThinkingSphinx::Test.index
    sleep 0.5
  end

  # -----------
  
  def teardown_sphinx
    DatabaseCleaner.strategy = :transaction
  end
  
  # -----------
  
  module ClassMethods
    # Takes the same arguments as make_content, but in hash form
    # spinx_spec(num: 10, options: { title: "Something"})
    def sphinx_spec(content_options={})
      before :all do
        setup_sphinx
      end
      
      before :each do
        make_content(content_options[:num], content_options[:options])
        index_sphinx
      end
      
      after :all do
        teardown_sphinx
      end
    end
  end
end


# ThinkingSphinx::Test.start does a few things:
# 1. generate config file
# 2. index sphinx
# 3. start sphinx

# To manually index
#     ThinkingSphinx::Test.index
